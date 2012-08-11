From: <kgudipat@brocade.com>
Subject: [RFC - PATCH 0/3] SCSI: Initiator based LUN Masking - SCSI mid-layer
Date: Fri, 10 Aug 2012 19:35:11 -0700
Message-ID: <1344652511-13899-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43513 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab2HKCfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2012 22:35:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, revers@redhat.com, michaelc@cs.wisc.edu, hch@infradead.org
Cc: adapter_linux_open_src_team@brocade.com, amathur@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James, All,

	The following RFC patch-set adds Initiator based LUN Masking support to SCSI mid-layer
	and tries to address the feedback we have received to have LUN Masking feature in the
	SCSI mid-layer and made available to everyone.

	We came up with a design proposal to implement LUN Masking in SCSI mid-layer.

	I have listed the proposal details below and also attached the RFC patch-set
	that enables LUN Masking in the SCSI mid-layer and the implementation of the
	LUN Masking feature by the Brocade BFA driver using the APIs provided by the
	SCSI mid-layer to support LUN Masking feature.

	Can you please review the design proposal, patches and please let us know your opinion?

Thanks in advance,
Krishna C Gudipati.

(LUN masked = LUN to be made visible)
==============================================================================
Proposal - LUN Masking implementation in the SCSI mid-layer using SCSI target
==============================================================================

Design Proposal:
================
Maintain a masked LUN list (the luns to be made visible) per target in the
SCSI target structure and use this list to determine whether to add the LUN
to the system config or to skip adding this LUN during the SCSI scan.

The masked LUN list can be populated during the LLD target_alloc() entry point
and can also be modified using the APIs that re-config this masked LUN list.
The re-config is followed by a SCSI scan to honor the modified masked LUN list.

Changed Required:
=================
New Attributes:
===============
	- Add a new list "masked_lun_list", which holds 'scsi_lun' structures
	  to the SCSI target structure "struct scsi_target".

	  struct scsi_target {
		. . .
		struct list_head	masked_lun_list;
		. . .
	  };

	- Add a new attribute "is_masking_enabled" in struct scsi_target that
	  indicates if the LUN Masking for this target is enabled or not.

	  struct scsi_target {
		. . .
		unsigned is_masking_enabled;
		. . .
	  };

	- Add a new attribute "is_masked" to the "struct scsi_device" to indicate
	  if this particular scsi_device is masked (to be made visible).

	  struct scsi_device {
		. . .
		unsigned is_masked:1;
		. . .
	  };

	- Add a new structure struct scsi_mask_lun which contains the list of
	  masked luns

	  struct scsi_mask_lun {
		struct list_head list_entry;
		struct scsi_lun mask_lun;
	  };

	- Introduce a status flag SCSI_SCAN_MASK_LUN, which is used by the SCSI scan
	  routines scsi_report_lun_scan() and scsi_sequential_lun_scan() to skip
	  adding this LUN and continue the SCSI target scan.

API changes:
============
	- Introduce APIs to add or remove LUNs from SCSI target masked_lun_list.

	  /*
	   * The function scsi_target_mask_lun() takes both the scsi_target and
	   * the LUN to be added to the masked_lun_list as the input and adds
	   * the LUN to the masked_lun_list if it has already been not added.
	   * The masked_lun_list is sorted by the LUN number.
	   */
	   extern int scsi_target_mask_lun(struct Scsi_Host *shost, int channel,
					   int target_id, unsigned int lun);

	  /*
	   * The function scsi_target_unmask_lun() takes both the scsi_target
	   * and the LUN to be removed from the masked_lun_list as the input and
	   * removes the LUN from the masked_lun_list if it exists.
	   * The masked_lun_list is sorted by the LUN number.
	   */
	   extern int scsi_target_unmask_lun(struct Scsi_Host *shost, int channel,
					     int target_id, unsigned int lun);

	- Introduce an API to set/unset LUN Masking configuration

	  /*
	   * The function scsi_target_config_lunmask() takes both the scsi_target
	   * and the masking_config as input and configures the LUN Masking per
	   * SCSI target; masking_config can be 1 or 0 where 1 - is to set and
	   * 0 - unset LUN Masking.
	   */
	   extern int scsi_target_config_lunmask(struct Scsi_Host *shost, int channel,
						 int target_id, int masking_config);

Pseudocode/Logic:
=================
Populating the "masked_lun_list":
=================================
  - During initial SCSI scan for each newly discovered target SCSI mid-layer will
    invoke LLD target_alloc() entry point for LLD to configure target specific data.

  - For implementing LUN Masking, LLD can add the list of LUNs that are to be
    masked to the scsi_target "masked_lun_list" in the target_alloc() entry point.

  - Further add/remove modifications to "masked_lun_list" can be done using APIs
    scsi_target_mask_lun() or scsi_target_unmask_lun() respectively.

Initial SCSI scan Flow:
=======================

__scsi_scan_target() {

    scsi_alloc_target() {

	xxx_target_alloc(starget) {	<-- LLD target_alloc() entry point

	   - Set scsi_target "is_masking_enabled" flag to enable LUN Masking
	     using the API scsi_target_config_lunmask();

	   - Add the LUNs to be masked to the masked_lun_list

	   list_add_tail(&slun->list_entry, &starget->masked_lun_list);

	   . . .
	}

   }

   scsi_probe_and_add_lun() {

	sdev = scsi_alloc_sdev();

	scsi_probe_lun();

	if (starget->is_masking_enabled) {

	    /*
	     * Check if the LUN is part of the scsi_target "masked_lun_list"
	     * If YES - set the sdev->is_masked flag for this particular LUN.
	     * It NOT - don't see the sdev->is_masked flag.
	     * Only the scsi_devices that have the is_masked flag set will be
	     * made visible in the sysfs.
	     */
	}

	. . .

	if (starget->is_masking_enabled) {
		if (sdev->is_masked)
			scsi_add_lun();
		else
			goto out_free_result;
	}

	. . .

    out_free_result:
	/* Remove scsi_device that is not part of LUN Masking list */
	/* Return status as SCSI_SCAN_MASK_LUN */
    . . .

    }
}

Note: The functions scsi_report_lun_scan() and scsi_sequential_lun_scan() when
      they receive the return status as SCSI_SCAN_MASK_LUN will skip adding this
      LUN and continue with the SCSI scan for rest of the LUNs.

SCSI Target Destroy:
===================
	- During the scsi_target_destroy() the masked_lun_list needs to be freed.

LUN Masking configuration change:
=================================
To enable LUN Masking from disabled state:
==========================================
    - Set LUN Masking in scsi_target using scsi_target_config_lunmask() API.
    - Add the list of visible luns to the "masked_lun_list".
    - Trigger a new LUN scan to reflect the new config.

    Handling already attached SCSI Devices:
    ---------------------------------------
    Flow:
    -----
    __scsi_scan_target() {
	scsi_probe_and_add_lun() {
		. . .
		sdev = scsi_device_lookup_by_target(starget, lun);
		if (sdev) {

		    /* Check if this LUN is part of the "masked_lun_list"
		     * If YES - set the sdev->is_masked to 1 and return
		     * SCSI_SCAN_LUN_PRESENT as done currently.
		     * If the LUN is NOT part of the "masked_lun_list" then
		     * remove this device using the __scsi_remove_device().
		     * The return status in this case will be SCSI_SCAN_MASK_LUN
		     */
		}
		. . .
	}
    }

To disable LUN Masking from enabled state:
==========================================
    - Unset LUN Masking in scsi_target using scsi_target_config_lunmask() API.
    - Trigger a new LUN scan to reflect the new config.

    Handling already attached SCSI Devices:
    ---------------------------------------
    Flow:
    -----
    __scsi_scan_target() {
	scsi_probe_and_add_lun() {
		. . .
		sdev = scsi_device_lookup_by_target(starget, lun);
		if (sdev) {
		    . . .
		    /* Unset the sdev->is_masked bit */
		    . . .
		}
		. . .
	}
    }

    Handling currently not-visible SCSI Devices:
    --------------------------------------------
    Flow:
    -----
    __scsi_scan_target() {
	scsi_probe_and_add_lun() {
		. . .
		- Add the discovered LUN to the sysfs.
		. . .
	}
    }

Pros:
=====
	- Implementation is not that complex
	- LLD can choose at run time / during SCSI scan LUNs to be masked.
	- SCSI Stack controls the device addition/removal during the scan
	  based on the LLD LUN masking config.
	- SCSI Stack maintains the list of masked luns.

Thanks,
Krishna C Gudipati.

Krishna Gudipati (3):
  SCSI: Implement LUN Masking in SCSI mid-layer.
  bfa: Revert current LUN Masking implementation using slave callouts
  bfa: Implement LUN Masking using SCSI mid-layer LUN Masking support.

 drivers/scsi/bfa/bfad_bsg.c |   56 ++++++++--
 drivers/scsi/bfa/bfad_im.c  |   96 +++++++++--------
 drivers/scsi/bfa/bfad_im.h  |   27 ++----
 drivers/scsi/scsi_scan.c    |  251 +++++++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi.h         |    8 ++
 include/scsi/scsi_device.h  |    9 ++
 6 files changed, 361 insertions(+), 86 deletions(-)

--
1.7.3.rc1
