From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi disks?
Date: Tue, 30 Aug 2016 13:43:00 -0700
Message-ID: <CAPcyv4hzda80kqNtyTUHL7_mpoiDzLvQaj5OQL9OxePU3BKjEw@mail.gmail.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com> <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
 <1471101800.2397.9.camel@HansenPartnership.com> <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
 <1471110212.2397.39.camel@HansenPartnership.com> <CAPcyv4gHq=RraHgcJGx_txk7YJHC8YQ3gCT4CHL0hvzsGpU1wg@mail.gmail.com>
 <1471195252.2355.18.camel@HansenPartnership.com> <cf141c9f-2bda-060a-0a7d-86638c2f5818@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34477 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbcH3UnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2016 16:43:02 -0400
Received: by mail-oi0-f53.google.com with SMTP id l203so43258433oib.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2016 13:43:01 -0700 (PDT)
In-Reply-To: <cf141c9f-2bda-060a-0a7d-86638c2f5818@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>

On Mon, Aug 29, 2016 at 11:16 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 08/14/2016 10:21 AM, James Bottomley wrote:
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index d3e852a..222771d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3000,7 +3000,13 @@ static void sd_probe_async(void *data, async_cook=
ie_t cookie)
>>       }
>>
>>       blk_pm_runtime_init(sdp->request_queue, dev);
>> -     device_add_disk(dev, gd);
>> +     /*
>> +      * previously the parent of the gendisk was the scsi device.  It
>> +      * was moved to fix lifetime rules, so now we install a symlink
>> +      * to the new location of the block class directory
>> +      */
>> +     device_add_disk(&sdkp->dev, gd);
>> +     WARN_ON(sysfs_add_link_to_group(&dev->kobj, "block", &sdkp->dev.ko=
bj, "block"));
>>       if (sdkp->capacity)
>>               sd_dif_config_host(sdkp);
>>
>> @@ -3142,6 +3148,7 @@ static int sd_remove(struct device *dev)
>>
>>       async_synchronize_full_domain(&scsi_sd_pm_domain);
>>       async_synchronize_full_domain(&scsi_sd_probe_domain);
>> +     sysfs_remove_link(&dev->kobj, "block");
>>       device_del(&sdkp->dev);
>>       del_gendisk(sdkp->disk);
>>       sd_shutdown(dev);
>
> Hello James,
>
> Sorry that it took so long before I could test this patch and
> the previous patch that was posted in this e-mail thread. But I
> did so earlier this morning. What I see is that the following
> warning message is reported frequently:
>
> WARNING: CPU: 1 PID: 136 at drivers/scsi/sd.c:3009 sd_probe_async+0x1ce/0=
x1e0
> Modules linked in: ib_srp libcrc32c scsi_transport_srp target_core_pscsi =
target_core_file ib_srpt target_core_iblock target_core_mod brd dm_multipat=
h scsi_dh_rdac scsi_dh_emc scsi_dh_alua netconsole xt_CHECKSUM iptable_mang=
le ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_=
conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_tcpud=
p tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_=
tables x_tables af_packet bridge stp llc iscsi_ibft iscsi_boot_sysfs ib_ipo=
ib rdma_ucm ib_ucm ib_uverbs ib_umad msr rdma_cm configfs ib_cm iw_cm mlx4_=
ib ib_core sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel kvm dm_mod irqbypass ipmi_ssif crct10dif_pclmul ipmi_devintf crc=
32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt aes_x86_64 lrw iTCO_vend=
or_support dcdbas gf128mul tg3 mlx4_core glue_helper ablk_helper ptp cryptd=
 fjes ipmi_si pcspkr pps_core libphy ipmi_msghandler mei_me tpm_tis tpm_tis=
_core mei tpm lpc_ich shpchp mfd_core wmi button hid_generic usbhid mgag200=
 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops =
ttm drm sr_mod cdrom crc32c_intel ehci_pci ehci_hcd usbcore usb_common sg [=
last unloaded: scsi_transport_srp]
> CPU: 1 PID: 136 Comm: kworker/u64:8 Tainted: G        W       4.8.0-rc4-d=
bg+ #2
> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
> Workqueue: events_unbound async_run_entry_fn
> Call Trace:
>  [<ffffffff813247c5>] dump_stack+0x68/0x93
>  [<ffffffff81062f96>] __warn+0xc6/0xe0
>  [<ffffffff81063068>] warn_slowpath_null+0x18/0x20
>  [<ffffffff8148145e>] sd_probe_async+0x1ce/0x1e0
>  [<ffffffff81089d64>] async_run_entry_fn+0x34/0x140
>  [<ffffffff81080355>] process_one_work+0x1f5/0x690
>  [<ffffffff81080839>] worker_thread+0x49/0x490
>  [<ffffffff8108701a>] kthread+0xea/0x100
>  [<ffffffff8162d3bf>] ret_from_fork+0x1f/0x40
>
> The test I ran is available at https://github.com/bvanassche/srp-test.

I tried running this, but it seems I'm failing to configure my test
environment correctly [1], but I'm worried that this "re-parenting the
scsi-disk" approach, even if the above warning is addressed, may not
be backwards compatible.  We now have an ordering difference where the
link to the "block" attribute group is established after the disk's
KOBJ_ADD event which seems in the same class of problems that Fam
Zheng's patchset [2] is trying to solve.

Bart, if you can help me get the test case running I can take a look
at finishing off the disk_devt approach I proposed earlier.

[1]: https://gist.github.com/djbw/1c72526c90d1ea8fe2a05dcfbfc73dda
[2]: https://lkml.org/lkml/2016/8/17/63
