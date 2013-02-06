From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: [PATCH v8 0/10] More device removal fixes
Date: Wed, 6 Feb 2013 17:31:45 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:58765 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3BFXIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2013 18:08:16 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On Tue, 5 Feb 2013, Bart Van Assche wrote:

> Fix a few race conditions that can be triggered by removing a device:
> - Fix a race between starved list processing and device removal.
> - Avoid that a SCSI LLD callback can get invoked after
>   scsi_remove_host() finished.
> - Speed up device removal by stopping error handling as soon as
>   the SHOST_DEL or SHOST_DEL_RECOVERY state has been reached.
> - Save and restore the host_scribble field during error handling
> 
> These patches have been tested on top of kernel v3.8-rc6 and are also
> available here: http://github.com/bvanassche/linux/tree/device-removal-fixes.

Hi Bart,

I gave your patchset a spin on our ftServer, which supports hotplug of PCI
devices.  Before attempting a surprise HW removal of an LSI Fusion SAS-2
SCSI controller, I issued an orderly removal through our hotplug driver.
The device removal appeared to hang (this does not occur with vanilla
3.8.0-rc6):
 
  PID: 3331   TASK: ffff88083e968000  CPU: 28  COMMAND: "java"
   #0 [ffff88084fd5da48] __schedule at ffffffff8165e8f4
   #1 [ffff88084fd5dac0] schedule at ffffffff8165f0d9
   #3 [ffff88084fd5db30] _scsih_remove at ffffffffa008416d [mpt2sas]
   #4 [ffff88084fd5db80] pci_device_remove at ffffffff81335e66
   #5 [ffff88084fd5dbb0] __device_release_driver at ffffffff813fd23c
   #6 [ffff88084fd5dbd0] device_release_driver at ffffffff813fd57c
   #7 [ffff88084fd5dbf0] bus_remove_device at ffffffff813fccde
   #8 [ffff88084fd5dc20] device_del at ffffffff813fa0ba
   #9 [ffff88084fd5dc50] device_unregister at ffffffff813fa172
  #10 [ffff88084fd5dc70] pci_stop_bus_device at ffffffff8132fce4
  #11 [ffff88084fd5dca0] pci_stop_bus_device at ffffffff8132fc8d
  #12 [ffff88084fd5dcd0] pci_stop_bus_device at ffffffff8132fc8d
  #13 [ffff88084fd5dd00] pci_stop_bus_device at ffffffff8132fc8d
  #14 [ffff88084fd5dd30] pci_stop_bus_device at ffffffff8132fc8d
  #15 [ffff88084fd5dd60] pci_stop_and_remove_bus_device at ffffffff8132fe46

And to further pin down where we are...

  crash> sym _scsih_remove
  ffffffffa0084010 (t) _scsih_remove [mpt2sas]
  crash> p/x 0xffffffffa008416d - 0xffffffffa0084010
  $9 = 0x15d
  
  crash> dis -l _scsih_remove
    <_scsih_remove+0x140>:  callq  0xffffffffa0011ea0 <sas_remove_host>
    <_scsih_remove+0x145>:  mov    %r13,%rdi
    <_scsih_remove+0x148>:  callq  0xffffffffa00766c0 <mpt2sas_base_detach>
    <_scsih_remove+0x14d>:  mov    %r13,%rdi
    <_scsih_remove+0x150>:  callq  0xffffffff8131b930 <list_del>
    <_scsih_remove+0x155>:  mov    %r12,%rdi
    <_scsih_remove+0x158>:  callq  0xffffffff8141dcf0 <scsi_remove_host>
    <_scsih_remove+0x15d>:  mov    %r12,%rdi
    <_scsih_remove+0x160>:  callq  0xffffffff8141d770 <scsi_host_put>
    <_scsih_remove+0x165>:  add    $0x18,%rsp

We're stuck in the mpt2sas driver's call to scsi_remove_host(), which
"[PATCH v8 07/10] Make scsi_remove_host() wait for device removal"
modifies.

I re-ran the test with some additional debugging so I could figure out the
Scsi_Host it was operating on and found:

  crash> struct Scsi_Host 0xffff8808513a4290 | grep eh_active
    eh_active = 0

However, its __devices list was not empty:

  crash> struct Scsi_Host 0xffff8808513a4290 | grep __devices -A3
    __devices = {
      next = 0xffff880851232530, 
      prev = 0xffff880851235398
    },

So scsi_remove_host loops while the __devices list is never cleared. 

See a complete dump of Scsi_Host and the __devices_list scsi_devices
below.

Regards,

-- Joe


crash> struct Scsi_Host 0xffff8808513a4290 > shost

struct Scsi_Host {
  __devices = {
    next = 0xffff880851232530, 
    prev = 0xffff880851235398
  }, 
  __targets = {
    next = 0xffff881054377980, 
    prev = 0xffff88084ed99528
  }, 
  cmd_pool = 0xffffffff81c956c0, 
  free_list_lock = {
    {
      rlock = {
        raw_lock = {
          {
            head_tail = 0x2e2e, 
            tickets = {
              head = 0x2e, 
              tail = 0x2e
            }
          }
        }
      }
    }
  }, 
  free_list = {
    next = 0xffff88084fb6c008, 
    prev = 0xffff88084fb6c008
  }, 
  starved_list = {
    next = 0xffff8808513a42d0, 
    prev = 0xffff8808513a42d0
  }, 
  default_lock = {
    {
      rlock = {
        raw_lock = {
          {
            head_tail = 0xe5e5, 
            tickets = {
              head = 0xe5, 
              tail = 0xe5
            }
          }
        }
      }
    }
  }, 
  host_lock = 0xffff8808513a42e0, 
  scan_mutex = {
    count = {
      counter = 0x1
    }, 
    wait_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x0, 
              tickets = {
                head = 0x0, 
                tail = 0x0
              }
            }
          }
        }
      }
    }, 
    wait_list = {
      next = 0xffff8808513a42f8, 
      prev = 0xffff8808513a42f8
    }, 
    owner = 0x0
  }, 
  eh_cmd_q = {
    next = 0xffff8808513a4310, 
    prev = 0xffff8808513a4310
  }, 
  ehandler = 0xffff8808512d1890, 
  eh_action = 0x0, 
  eh_active = 0x0, 
  host_wait = {
    lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x0, 
              tickets = {
                head = 0x0, 
                tail = 0x0
              }
            }
          }
        }
      }
    }, 
    task_list = {
      next = 0xffff8808513a4340, 
      prev = 0xffff8808513a4340
    }
  }, 
  remove_host = {
    lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x101, 
              tickets = {
                head = 0x1, 
                tail = 0x1
              }
            }
          }
        }
      }
    }, 
    task_list = {
      next = 0xffff88103712faa8, 
      prev = 0xffff88103712faa8
    }
  }, 
  hostt = 0xffffffffa00cc1c0, 
  transportt = 0xffff880850c233d8, 
  bqt = 0x0, 
  host_busy = 0x0, 
  host_failed = 0x0, 
  host_eh_scheduled = 0x0, 
  host_no = 0x0, 
  resetting = 0x0, 
  last_reset = 0x0, 
  max_id = 0xffffffff, 
  max_lun = 0x41ff, 
  max_channel = 0x0, 
  unique_id = 0x0, 
  max_cmd_len = 0x20, 
  this_id = 0xffffffff, 
  can_queue = 0xdfb, 
  cmd_per_lun = 0x7, 
  sg_tablesize = 0x80, 
  sg_prot_tablesize = 0x0, 
  max_sectors = 0x7fff, 
  dma_boundary = 0xffffffff, 
  cmd_serial_number = 0x152f, 
  active_mode = 0x1, 
  unchecked_isa_dma = 0x0, 
  use_clustering = 0x1, 
  use_blk_tcq = 0x0, 
  host_self_blocked = 0x0, 
  reverse_ordering = 0x0, 
  ordered_tag = 0x0, 
  tmf_in_progress = 0x0, 
  async_scan = 0x0, 
  eh_noresume = 0x0, 
  work_q_name = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000", 
  work_q = 0x0, 
  host_blocked = 0x0, 
  max_host_blocked = 0x7, 
  prot_capabilities = 0x7, 
  prot_guard_type = 0x1, 
  uspace_req_q = 0x0, 
  base = 0x0, 
  io_port = 0x0, 
  n_io_port = 0x0, 
  dma_channel = 0xff, 
  irq = 0x0, 
  shost_state = SHOST_DEL, 
  shost_gendev = {
    parent = 0xffff881053a92328, 
    p = 0xffff880850ccca28, 
    kobj = {
      name = 0xffff88084fa2e220 "host0", 
      entry = {
        next = 0xffff8808513a46c8, 
        prev = 0xffff880851225498
      }, 
      parent = 0xffff881053a92338, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0xffff88084fb65658, 
      kref = {
        refcount = {
          counter = 0xe
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x1, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x0, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0xffffffff81c95780, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff8808513a4498, 
        prev = 0xffff8808513a4498
      }, 
      owner = 0x0
    }, 
    bus = 0xffffffff81c95960, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0x0
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0xf0f, 
                tickets = {
                  head = 0xf, 
                  tail = 0xf
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff8808513a4750, 
        prev = 0xffff880851225520
      }, 
      completion = {
        done = 0x7fffffff, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x101, 
                    tickets = {
                      head = 0x1, 
                      tail = 0x1
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff8808513a44f0, 
            prev = 0xffff8808513a44f0
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff880854090000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff8808513a4430, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff8808513a4570, 
          prev = 0xffff8808513a4570
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x303, 
                  tickets = {
                    head = 0x3, 
                    tail = 0x3
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff8808513a4590, 
          prev = 0xffff8808513a4590
        }
      }, 
      usage_count = {
        counter = 0x1
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x0, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x1, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_ACTIVE, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x119, 
      suspended_jiffies = 0x199ea, 
      accounting_timestamp = 0xfffd2888, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff8808513a4618, 
      prev = 0xffff8808513a4618
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x0, 
              tickets = {
                head = 0x0, 
                tail = 0x0
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff8808513a4660, 
      prev = 0xffff8808513a4660
    }, 
    knode_class = {
      n_klist = 0x0, 
      n_node = {
        next = 0x0, 
        prev = 0x0
      }, 
      n_ref = {
        refcount = {
          counter = 0x0
        }
      }
    }, 
    class = 0x0, 
    groups = 0x0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  shost_dev = {
    parent = 0xffff8808513a4430, 
    p = 0xffff880850cccc30, 
    kobj = {
      name = 0xffff88084fa2dce0 "host0", 
      entry = {
        next = 0xffff88084fb87448, 
        prev = 0xffff8808513a4448
      }, 
      parent = 0xffff8808513e31b0, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0xffff88084fb78370, 
      kref = {
        refcount = {
          counter = 0x3
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x1, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x0, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0x0, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff8808513a4718, 
        prev = 0xffff8808513a4718
      }, 
      owner = 0x0
    }, 
    bus = 0x0, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0x0
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff88084fb874d0, 
        prev = 0xffff8808513a44d0
      }, 
      completion = {
        done = 0x7fffffff, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x101, 
                    tickets = {
                      head = 0x1, 
                      tail = 0x1
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff8808513a4770, 
            prev = 0xffff8808513a4770
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff880854090000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff8808513a46b0, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff8808513a47f0, 
          prev = 0xffff8808513a47f0
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x0, 
                  tickets = {
                    head = 0x0, 
                    tail = 0x0
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff8808513a4810, 
          prev = 0xffff8808513a4810
        }
      }, 
      usage_count = {
        counter = 0x0
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x1, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x1, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_SUSPENDED, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x0, 
      suspended_jiffies = 0x0, 
      accounting_timestamp = 0xfffb8d5b, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff8808513a4898, 
      prev = 0xffff8808513a4898
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x0, 
              tickets = {
                head = 0x0, 
                tail = 0x0
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff8808513a48e0, 
      prev = 0xffff8808513a48e0
    }, 
    knode_class = {
      n_klist = 0xffff880853dc8730, 
      n_node = {
        next = 0xffff8808513a27b0, 
        prev = 0xffff880853dc8738
      }, 
      n_ref = {
        refcount = {
          counter = 0x1
        }
      }
    }, 
    class = 0xffffffff81c957c0, 
    groups = 0xffffffff81c959e0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  sht_legacy_list = {
    next = 0x0, 
    prev = 0x0
  }, 
  shost_data = 0xffff8808513e3008, 
  dma_dev = 0xffff881053a92328, 
  hostdata = 0xffff8808513a4950
}


crash> list scsi_device.siblings -H 0xffff8808513a4290 -s scsi_device

ffff880851232520
struct scsi_device {
  host = 0xffff8808513a4290, 
  request_queue = 0xffff88085107ad78, 
  siblings = {
    next = 0xffff880851235398, 
    prev = 0xffff8808513a4290
  }, 
  same_target_siblings = {
    next = 0xffff881054377990, 
    prev = 0xffff881054377990
  }, 
  device_busy = 0x0, 
  list_lock = {
    {
      rlock = {
        raw_lock = {
          {
            head_tail = 0x2626, 
            tickets = {
              head = 0x26, 
              tail = 0x26
            }
          }
        }
      }
    }
  }, 
  cmd_list = {
    next = 0xffff880851232558, 
    prev = 0xffff880851232558
  }, 
  starved_entry = {
    next = 0xdead000000100100, 
    prev = 0xdead000000200200
  }, 
  current_cmnd = 0x0, 
  queue_depth = 0xfe, 
  max_queue_depth = 0xfe, 
  last_queue_full_depth = 0x0, 
  last_queue_full_count = 0x0, 
  last_queue_full_time = 0x0, 
  queue_ramp_up_period = 0x1d4c0, 
  last_queue_ramp_up = 0x0, 
  id = 0x0, 
  lun = 0x0, 
  channel = 0x0, 
  manufacturer = 0x0, 
  sector_size = 0x200, 
  hostdata = 0x0, 
  type = 0x0, 
  scsi_level = 0x7, 
  inq_periph_qual = 0x0, 
  inquiry_len = 0x90, 
  inquiry = 0xffff88084ec2e8a0 "", 
  vendor = 0xffff88084ec2e8a8 "SEAGATE ST9300653SS     00026XN020GG", 
  model = 0xffff88084ec2e8b0 "ST9300653SS     00026XN020GG", 
  rev = 0xffff88084ec2e8c0 "00026XN020GG", 
  current_tag = 0x0, 
  sdev_target = 0xffff881054377978, 
  sdev_bflags = 0x0, 
  writeable = 0x1, 
  removable = 0x0, 
  changed = 0x0, 
  busy = 0x0, 
  lockable = 0x0, 
  locked = 0x0, 
  borken = 0x0, 
  disconnect = 0x0, 
  soft_reset = 0x0, 
  sdtr = 0x0, 
  wdtr = 0x0, 
  ppr = 0x1, 
  tagged_supported = 0x1, 
  simple_tags = 0x0, 
  ordered_tags = 0x0, 
  was_reset = 0x0, 
  expecting_cc_ua = 0x0, 
  use_10_for_rw = 0x1, 
  use_10_for_ms = 0x0, 
  no_report_opcodes = 0x0, 
  no_write_same = 0x0, 
  use_16_for_rw = 0x0, 
  skip_ms_page_8 = 0x0, 
  skip_ms_page_3f = 0x0, 
  skip_vpd_pages = 0x0, 
  use_192_bytes_for_3f = 0x0, 
  no_start_on_add = 0x0, 
  allow_restart = 0x0, 
  manage_start_stop = 0x0, 
  start_stop_pwr_cond = 0x0, 
  no_uld_attach = 0x0, 
  select_no_atn = 0x0, 
  fix_capacity = 0x0, 
  guess_capacity = 0x0, 
  retry_hwerror = 0x0, 
  last_sector_bug = 0x0, 
  no_read_disc_info = 0x0, 
  no_read_capacity_16 = 0x0, 
  try_rc_10_first = 0x0, 
  is_visible = 0x1, 
  can_power_off = 0x0, 
  wce_default_on = 0x0, 
  no_dif = 0x0, 
  supported_events = {0x0}, 
  event_list = {
    next = 0xffff880851232610, 
    prev = 0xffff880851232610
  }, 
  event_work = {
    data = {
      counter = 0x10200
    }, 
    entry = {
      next = 0xffff880851232628, 
      prev = 0xffff880851232628
    }, 
    func = 0xffffffff81426020 <scsi_evt_thread>
  }, 
  device_blocked = 0x0, 
  max_device_blocked = 0x3, 
  iorequest_cnt = {
    counter = 0x1313
  }, 
  iodone_cnt = {
    counter = 0x1313
  }, 
  ioerr_cnt = {
    counter = 0x0
  }, 
  sdev_gendev = {
    parent = 0xffff8810543779a0, 
    p = 0xffff88084edab6d8, 
    kobj = {
      name = 0xffff88084ec48540 "0:0:0:0", 
      entry = {
        next = 0xffff880851232670, 
        prev = 0xffff880851232670
      }, 
      parent = 0x0, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0x0, 
      kref = {
        refcount = {
          counter = 0x2
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x0, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x1, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0xffffffff81c95ac0, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff8808512326c0, 
        prev = 0xffff8808512326c0
      }, 
      owner = 0x0
    }, 
    bus = 0xffffffff81c95960, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0xffffffff
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x2b2b, 
                tickets = {
                  head = 0x2b, 
                  tail = 0x2b
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff8808512326f8, 
        prev = 0xffff8808512326f8
      }, 
      completion = {
        done = 0xfffffffe, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x202, 
                    tickets = {
                      head = 0x2, 
                      tail = 0x2
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff880851232718, 
            prev = 0xffff880851232718
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff8808546f4000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff880851232658, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff880851232798, 
          prev = 0xffff880851232798
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x0, 
                  tickets = {
                    head = 0x0, 
                    tail = 0x0
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff8808512327b8, 
          prev = 0xffff8808512327b8
        }
      }, 
      usage_count = {
        counter = 0x3
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x1, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x0, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_SUSPENDED, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x0, 
      suspended_jiffies = 0x0, 
      accounting_timestamp = 0xfffd24fd, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff880851232840, 
      prev = 0xffff880851232840
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x202, 
              tickets = {
                head = 0x2, 
                tail = 0x2
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff880851232888, 
      prev = 0xffff880851232888
    }, 
    knode_class = {
      n_klist = 0x0, 
      n_node = {
        next = 0x0, 
        prev = 0x0
      }, 
      n_ref = {
        refcount = {
          counter = 0x0
        }
      }
    }, 
    class = 0x0, 
    groups = 0x0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  sdev_dev = {
    parent = 0xffff880851232658, 
    p = 0xffff88084edab2c8, 
    kobj = {
      name = 0xffff88084ec48a80 "kkkkkkk\245\273\273\273\273\273\273\273\273p\216\304N\b\210\377\377\261\222\060\201\377\377\377\377y\216e\201\377\377\377\377?\356\030\201\377\377\377\377{U1\201\377\377\377\377\261\222\060\201\377\377\377\377\241\221?\201\377\377\377\377\250\245B\201\377\377\377\377\256fB\201\377\377\377\377\247kB\201\377\377\377\377\201{B\201\377\377\377\377", 
      entry = {
        next = 0xffff8808512328f0, 
        prev = 0xffff8808512328f0
      }, 
      parent = 0x0, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0x0, 
      kref = {
        refcount = {
          counter = 0x0
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x0, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x1, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0x0, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff880851232940, 
        prev = 0xffff880851232940
      }, 
      owner = 0x0
    }, 
    bus = 0x0, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0xffffffff
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x101, 
                tickets = {
                  head = 0x1, 
                  tail = 0x1
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff880851232978, 
        prev = 0xffff880851232978
      }, 
      completion = {
        done = 0xfffffffe, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x202, 
                    tickets = {
                      head = 0x2, 
                      tail = 0x2
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff880851232998, 
            prev = 0xffff880851232998
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff8808546f4000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff8808512328d8, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff880851232a18, 
          prev = 0xffff880851232a18
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x0, 
                  tickets = {
                    head = 0x0, 
                    tail = 0x0
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff880851232a38, 
          prev = 0xffff880851232a38
        }
      }, 
      usage_count = {
        counter = 0x0
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x2, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x1, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_SUSPENDED, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x0, 
      suspended_jiffies = 0x0, 
      accounting_timestamp = 0xfffb8e97, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff880851232ac0, 
      prev = 0xffff880851232ac0
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x101, 
              tickets = {
                head = 0x1, 
                tail = 0x1
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff880851232b08, 
      prev = 0xffff880851232b08
    }, 
    knode_class = {
      n_klist = 0x0, 
      n_node = {
        next = 0xdead000000100100, 
        prev = 0xdead000000200200
      }, 
      n_ref = {
        refcount = {
          counter = 0x0
        }
      }
    }, 
    class = 0xffffffff81c95a40, 
    groups = 0x0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  ew = {
    work = {
      data = {
        counter = 0x0
      }, 
      entry = {
        next = 0x0, 
        prev = 0x0
      }, 
      func = 0
    }
  }, 
  requeue_work = {
    data = {
      counter = 0x10200
    }, 
    entry = {
      next = 0xffff880851232b80, 
      prev = 0xffff880851232b80
    }, 
    func = 0xffffffff814257c0 <scsi_requeue_run_queue>
  }, 
  scsi_dh_data = 0x0, 
  sdev_state = SDEV_DEL, 
  sdev_data = 0xffff880851232ba8
}
ffff880851235388
struct scsi_device {
  host = 0xffff8808513a4290, 
  request_queue = 0xffff88085107b690, 
  siblings = {
    next = 0xffff8808513a4290, 
    prev = 0xffff880851232530
  }, 
  same_target_siblings = {
    next = 0xffff88084ed99538, 
    prev = 0xffff88084ed99538
  }, 
  device_busy = 0x0, 
  list_lock = {
    {
      rlock = {
        raw_lock = {
          {
            head_tail = 0x3636, 
            tickets = {
              head = 0x36, 
              tail = 0x36
            }
          }
        }
      }
    }
  }, 
  cmd_list = {
    next = 0xffff8808512353c0, 
    prev = 0xffff8808512353c0
  }, 
  starved_entry = {
    next = 0xdead000000100100, 
    prev = 0xdead000000200200
  }, 
  current_cmnd = 0x0, 
  queue_depth = 0xfe, 
  max_queue_depth = 0xfe, 
  last_queue_full_depth = 0x0, 
  last_queue_full_count = 0x0, 
  last_queue_full_time = 0x0, 
  queue_ramp_up_period = 0x1d4c0, 
  last_queue_ramp_up = 0x0, 
  id = 0x1, 
  lun = 0x0, 
  channel = 0x0, 
  manufacturer = 0x0, 
  sector_size = 0x200, 
  hostdata = 0x0, 
  type = 0x0, 
  scsi_level = 0x7, 
  inq_periph_qual = 0x0, 
  inquiry_len = 0x90, 
  inquiry = 0xffff88084eda8410 "", 
  vendor = 0xffff88084eda8418 "SEAGATE ST9146853SS     00026XM02L18", 
  model = 0xffff88084eda8420 "ST9146853SS     00026XM02L18", 
  rev = 0xffff88084eda8430 "00026XM02L18", 
  current_tag = 0x0, 
  sdev_target = 0xffff88084ed99520, 
  sdev_bflags = 0x0, 
  writeable = 0x1, 
  removable = 0x0, 
  changed = 0x0, 
  busy = 0x0, 
  lockable = 0x0, 
  locked = 0x0, 
  borken = 0x0, 
  disconnect = 0x0, 
  soft_reset = 0x0, 
  sdtr = 0x0, 
  wdtr = 0x0, 
  ppr = 0x1, 
  tagged_supported = 0x1, 
  simple_tags = 0x0, 
  ordered_tags = 0x0, 
  was_reset = 0x0, 
  expecting_cc_ua = 0x0, 
  use_10_for_rw = 0x1, 
  use_10_for_ms = 0x0, 
  no_report_opcodes = 0x0, 
  no_write_same = 0x0, 
  use_16_for_rw = 0x0, 
  skip_ms_page_8 = 0x0, 
  skip_ms_page_3f = 0x0, 
  skip_vpd_pages = 0x0, 
  use_192_bytes_for_3f = 0x0, 
  no_start_on_add = 0x0, 
  allow_restart = 0x0, 
  manage_start_stop = 0x0, 
  start_stop_pwr_cond = 0x0, 
  no_uld_attach = 0x0, 
  select_no_atn = 0x0, 
  fix_capacity = 0x0, 
  guess_capacity = 0x0, 
  retry_hwerror = 0x0, 
  last_sector_bug = 0x0, 
  no_read_disc_info = 0x0, 
  no_read_capacity_16 = 0x0, 
  try_rc_10_first = 0x0, 
  is_visible = 0x1, 
  can_power_off = 0x0, 
  wce_default_on = 0x0, 
  no_dif = 0x0, 
  supported_events = {0x0}, 
  event_list = {
    next = 0xffff880851235478, 
    prev = 0xffff880851235478
  }, 
  event_work = {
    data = {
      counter = 0x10200
    }, 
    entry = {
      next = 0xffff880851235490, 
      prev = 0xffff880851235490
    }, 
    func = 0xffffffff81426020 <scsi_evt_thread>
  }, 
  device_blocked = 0x0, 
  max_device_blocked = 0x3, 
  iorequest_cnt = {
    counter = 0x21b
  }, 
  iodone_cnt = {
    counter = 0x21b
  }, 
  ioerr_cnt = {
    counter = 0x0
  }, 
  sdev_gendev = {
    parent = 0xffff88084ed99548, 
    p = 0xffff88084eda8e38, 
    kobj = {
      name = 0xffff88084eda0540 "0:0:1:0", 
      entry = {
        next = 0xffff8808512354d8, 
        prev = 0xffff8808512354d8
      }, 
      parent = 0x0, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0x0, 
      kref = {
        refcount = {
          counter = 0x2
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x0, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x1, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0xffffffff81c95ac0, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff880851235528, 
        prev = 0xffff880851235528
      }, 
      owner = 0x0
    }, 
    bus = 0xffffffff81c95960, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0xffffffff
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0xc4c4, 
                tickets = {
                  head = 0xc4, 
                  tail = 0xc4
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff880851235560, 
        prev = 0xffff880851235560
      }, 
      completion = {
        done = 0xfffffffe, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x202, 
                    tickets = {
                      head = 0x2, 
                      tail = 0x2
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff880851235580, 
            prev = 0xffff880851235580
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff8808546f4000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff8808512354c0, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff880851235600, 
          prev = 0xffff880851235600
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x0, 
                  tickets = {
                    head = 0x0, 
                    tail = 0x0
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff880851235620, 
          prev = 0xffff880851235620
        }
      }, 
      usage_count = {
        counter = 0x3
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x1, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x0, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_SUSPENDED, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x0, 
      suspended_jiffies = 0x0, 
      accounting_timestamp = 0xfffd2515, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff8808512356a8, 
      prev = 0xffff8808512356a8
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x202, 
              tickets = {
                head = 0x2, 
                tail = 0x2
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff8808512356f0, 
      prev = 0xffff8808512356f0
    }, 
    knode_class = {
      n_klist = 0x0, 
      n_node = {
        next = 0x0, 
        prev = 0x0
      }, 
      n_ref = {
        refcount = {
          counter = 0x0
        }
      }
    }, 
    class = 0x0, 
    groups = 0x0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  sdev_dev = {
    parent = 0xffff8808512354c0, 
    p = 0xffff88084eda9248, 
    kobj = {
      name = 0xffff88084eda3870 "kkkkkkk\245\273\273\273\273\273\273\273\273\060\063\332N\b\210\377\377\261\222\060\201\377\377\377\377y\216e\201\377\377\377\377?\356\030\201\377\377\377\377{U1\201\377\377\377\377\261\222\060\201\377\377\377\377\241\221?\201\377\377\377\377\250\245B\201\377\377\377\377\256fB\201\377\377\377\377\247kB\201\377\377\377\377\201{B\201\377\377\377\377", 
      entry = {
        next = 0xffff880851235758, 
        prev = 0xffff880851235758
      }, 
      parent = 0x0, 
      kset = 0xffff88085f878b98, 
      ktype = 0xffffffff81c92240, 
      sd = 0x0, 
      kref = {
        refcount = {
          counter = 0x0
        }
      }, 
      state_initialized = 0x1, 
      state_in_sysfs = 0x0, 
      state_add_uevent_sent = 0x1, 
      state_remove_uevent_sent = 0x1, 
      uevent_suppress = 0x0
    }, 
    init_name = 0x0, 
    type = 0x0, 
    mutex = {
      count = {
        counter = 0x1
      }, 
      wait_lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x0, 
                tickets = {
                  head = 0x0, 
                  tail = 0x0
                }
              }
            }
          }
        }
      }, 
      wait_list = {
        next = 0xffff8808512357a8, 
        prev = 0xffff8808512357a8
      }, 
      owner = 0x0
    }, 
    bus = 0x0, 
    driver = 0x0, 
    platform_data = 0x0, 
    power = {
      power_state = {
        event = 0xffffffff
      }, 
      can_wakeup = 0x0, 
      async_suspend = 0x1, 
      is_prepared = 0x0, 
      is_suspended = 0x0, 
      ignore_children = 0x0, 
      early_init = 0x1, 
      lock = {
        {
          rlock = {
            raw_lock = {
              {
                head_tail = 0x101, 
                tickets = {
                  head = 0x1, 
                  tail = 0x1
                }
              }
            }
          }
        }
      }, 
      entry = {
        next = 0xffff8808512357e0, 
        prev = 0xffff8808512357e0
      }, 
      completion = {
        done = 0xfffffffe, 
        wait = {
          lock = {
            {
              rlock = {
                raw_lock = {
                  {
                    head_tail = 0x202, 
                    tickets = {
                      head = 0x2, 
                      tail = 0x2
                    }
                  }
                }
              }
            }
          }, 
          task_list = {
            next = 0xffff880851235800, 
            prev = 0xffff880851235800
          }
        }
      }, 
      wakeup = 0x0, 
      wakeup_path = 0x0, 
      syscore = 0x0, 
      suspend_timer = {
        entry = {
          next = 0x0, 
          prev = 0x0
        }, 
        expires = 0x0, 
        base = 0xffff8808546f4000, 
        function = 0xffffffff814092d0 <pm_suspend_timer_fn>, 
        data = 0xffff880851235740, 
        slack = 0xffffffff, 
        start_pid = 0xffffffff, 
        start_site = 0x0, 
        start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
      }, 
      timer_expires = 0x0, 
      work = {
        data = {
          counter = 0x10200
        }, 
        entry = {
          next = 0xffff880851235880, 
          prev = 0xffff880851235880
        }, 
        func = 0xffffffff8140a6b0 <pm_runtime_work>
      }, 
      wait_queue = {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 0x0, 
                  tickets = {
                    head = 0x0, 
                    tail = 0x0
                  }
                }
              }
            }
          }
        }, 
        task_list = {
          next = 0xffff8808512358a0, 
          prev = 0xffff8808512358a0
        }
      }, 
      usage_count = {
        counter = 0x0
      }, 
      child_count = {
        counter = 0x0
      }, 
      disable_depth = 0x2, 
      idle_notification = 0x0, 
      request_pending = 0x0, 
      deferred_resume = 0x0, 
      run_wake = 0x0, 
      runtime_auto = 0x1, 
      no_callbacks = 0x0, 
      irq_safe = 0x0, 
      use_autosuspend = 0x0, 
      timer_autosuspends = 0x0, 
      request = RPM_REQ_NONE, 
      runtime_status = RPM_SUSPENDED, 
      runtime_error = 0x0, 
      autosuspend_delay = 0x0, 
      last_busy = 0x0, 
      active_jiffies = 0x0, 
      suspended_jiffies = 0x0, 
      accounting_timestamp = 0xfffb8e9a, 
      subsys_data = 0x0, 
      qos = 0x0
    }, 
    pm_domain = 0x0, 
    numa_node = 0xffffffff, 
    dma_mask = 0x0, 
    coherent_dma_mask = 0x0, 
    dma_parms = 0x0, 
    dma_pools = {
      next = 0xffff880851235928, 
      prev = 0xffff880851235928
    }, 
    dma_mem = 0x0, 
    archdata = {
      dma_ops = 0x0, 
      iommu = 0x0
    }, 
    of_node = 0x0, 
    acpi_node = {
      handle = 0x0
    }, 
    devt = 0x0, 
    id = 0x0, 
    devres_lock = {
      {
        rlock = {
          raw_lock = {
            {
              head_tail = 0x101, 
              tickets = {
                head = 0x1, 
                tail = 0x1
              }
            }
          }
        }
      }
    }, 
    devres_head = {
      next = 0xffff880851235970, 
      prev = 0xffff880851235970
    }, 
    knode_class = {
      n_klist = 0x0, 
      n_node = {
        next = 0xdead000000100100, 
        prev = 0xdead000000200200
      }, 
      n_ref = {
        refcount = {
          counter = 0x0
        }
      }
    }, 
    class = 0xffffffff81c95a40, 
    groups = 0x0, 
    release = 0, 
    iommu_group = 0x0
  }, 
  ew = {
    work = {
      data = {
        counter = 0x0
      }, 
      entry = {
        next = 0x0, 
        prev = 0x0
      }, 
      func = 0
    }
  }, 
  requeue_work = {
    data = {
      counter = 0x10200
    }, 
    entry = {
      next = 0xffff8808512359e8, 
      prev = 0xffff8808512359e8
    }, 
    func = 0xffffffff814257c0 <scsi_requeue_run_queue>
  }, 
  scsi_dh_data = 0x0, 
  sdev_state = SDEV_DEL, 
  sdev_data = 0xffff880851235a10
}
