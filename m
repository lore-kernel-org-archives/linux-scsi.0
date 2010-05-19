From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [ANNOUNCE] - TCM/LIO v3.4.0
Date: Wed, 19 May 2010 16:16:01 -0700
Message-ID: <1274310961.25793.29.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: openfcoe-devel <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

I am happy to announce that the v3.4.0 stable release of TCM/LIO has
been tagged and branched into lio-core-2.6.git/lio-3.4.  This release is
now tracking upstream linux-2.6.34.y.git for future stable kernel
releases.

There where a number changes during the 3.4 development cycle to
TCM-Core to handle multi-fabric persistent reservations with SPEC_I_PT=1
and REGISTER_AND_MOVE ops correctly, as well as proper ALL_TG_PT=1
support and processing of SPC-3 TransportIDs containing a iSCSI
InitiatorName+ISID tuple.

This also included a handful of bugfixes and improvements including
minor changes to follow new TCM struct target_core_fabric_ops usage for
the LIO-Target (iSCSI), TCM_FC (OpenFCoE+libfc) and TCM_Loop (Virtual
SAS + SG_IO)

Thanks to everyone who contributed their patches, bug reports, testing
and time.  Below is the complete changelog.

Best,

--nab

Joe Eykholt (7):
  tcm: add tcm_fc
  tcm_fc: handle residual count
  tcm_fc: add task management support
  tcm_fc: allocate se_cmd in thread, not in softirq.
  tcm_fc: fix session lookup and get lport events
  tcm_fc: clean up tport/tpg pointers
  tcm_fc: distinguish task management debug from other debug messages

Nicholas Bellinger (42):
  [TCM/ConfigFS]: Fix leak of se_hba_t in
    target_core_call_addhbatotarget()
  [TCM]: Force SPC-3 passthrough emulation logic for
    HBA_FLAGS_INTERNAL_USE case
  [TCM]: Add HBA and Device setup for RAMDISK_DR virtual LUN=0
  [TCM]: Add TPG setup for RAMDISK_DR virtual LUN=0
  [TCM]: Modify __transport_get_lun_for_cmd() to support virtual LUN=0
  [TCM_Loop]: Add ALUA target port configfs attributes
  [tcm_fc]: Add ALUA target port configfs attributes
  [tcm_fc]: Add missing core_tpg_deregister() in ft_del_tpg()
  [tcm_fc]: Convert ft_get_pr_transport_id() to use local initiator
    WWPN
  [tcm_fc]: Convert TCM_FC/ConfigFS NodeACL and MappedLUN logic to use
    TCM v3.x struct config_groups
  [TCM/PR]: Add proper comment for implict RELEASE with All Registrants
  [TCM]: Declare core_tpg_get_initiator_node_acl() as extern
  [TCM]: Add base logic for struct se_portal_group_t->tpg_pr_ref_count
  [TCM]: Add base logic for struct se_node_acl_s->acl_pr_ref_count
  [TCM]: Add base logic for struct se_dev_entry_s->pr_ref_count
  [TCM/PR]: Add TPG, NodeACL and MappedLUN wrappers for
    configfs_[un]depend_item()
  [TCM/PR]: Convert REGISTER_AND_MOVE use new configfs dependency
    wrappers
  [TCM/PR]: Add support for intra-fabric SPEC_I_PT=1 TransportID
    processing
  Bump version to v3.4.0-rc1
  [TCM/PR]: Fix SPEC_I_PT=1 exception path for illegal TransportID
    payload length
  [TCM/PR]: Add proper ALL_TG_PT=1 allocation support
  [TCM/PR]: Add proper dest_node_acl failure case for SPEC_I_PT=1
  [TCM/PR]: Add proper ALL_TG_PT=1 UNREGISTER support
  [TCM/PR]: Add missing APTPL=1 metadata update for changing
    reservation key
  [TCM]: Convert utsrelease.h includes to include/generated/
  [TCM]: Add proper support for multiple se_session_t per se_node_acl_t
  [TCM]: Add t10_pr_registration_t *parameter to
    tpg_get_pr_transport_id*()
  [LIO-Target]: Convert lio_sess_get_initiator_wwn() and
    lio_tpg_get_pr_transport_id*()
  [TCM-FC]: Clear ft_fabric_ops->sess_get_initiator_sid() and update
    ft_get_pr_transport_id*()
  [TCM-Loop]: Clear fabric->tf_ops->sess_get_initiator_sid() and update
    tcm_loop_get_pr_transport_id*()
  [TCM/PR]: Add proper support for ISIDs in TransportID processing
  [TCM/PR]: Replace usage of DEF_PR_REGISTERED with
    *core_scsi3_locate_pr_reg()
  [TCM/PR]: Update APTPL metadata logic for ISIDs in TransportID
    processing
  [TCM/ConfigFS]: Add per-device attribute 'enforce_pr_isids'
  [TCM/ALUA]: Fix se_cmd_t->se_cmd_flags assignment bug in
    core_alua_state_nonoptimized()
  lio-core v3.4.0-rc2
  [LIO-Target]: Fix compile breakage with LIO_TARGET_DEBUG
  [LIO-Target]: Add iscsi_na_get_initiatorname() for TRACE_NODEATTRIB
  [TCM]: Fix core_dev_setup_virtual_lun0() failure path in
    target_core_init_configfs()
  [TCM]: Fix EVPD SCSI Name length calculation bug
  [TCM_Loop]: Fix debug option typo in Kbuild
  [TCM_Loop]: Add proper HBA defaults to struct Scsi_Host
