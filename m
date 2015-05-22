From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v2 0/9] target: se_node_acl + se_lun RCU conversions
Date: Fri, 22 May 2015 12:15:31 +0200
Message-ID: <555F01C3.3020301@sandisk.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/15 08:11, Nicholas A. Bellinger wrote:
> Here is -v2 series for converting LIO target se_node_acl + se_lun
> mapping tables from fixed size arrays to dynamic RCU hlist_heads.

The full list of new sparse warnings introduced by this patch series for
source files under drivers/target is as follows:

$ make M=drivers/target C=2
  CHECK   drivers/target/target_core_configfs.c
  CC [M]  drivers/target/target_core_configfs.o
  CHECK   drivers/target/target_core_device.c
drivers/target/target_core_device.c:89:24: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:89:24:    expected struct se_lun *se_lun
drivers/target/target_core_device.c:89:24:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:90:32: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:90:32:    expected struct se_lun *se_lun
drivers/target/target_core_device.c:90:32:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:130:24: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:130:24:    expected struct se_device *se_dev
drivers/target/target_core_device.c:130:24:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:132:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:132:13:    expected struct se_device *dev
drivers/target/target_core_device.c:132:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:158:33: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:158:33:    expected struct se_lun *tmr_lun
drivers/target/target_core_device.c:158:33:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:159:32: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:159:32:    expected struct se_lun *se_lun
drivers/target/target_core_device.c:159:32:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:160:24: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:160:24:    expected struct se_lun *se_lun
drivers/target/target_core_device.c:160:24:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:175:24: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:175:24:    expected struct se_device *se_dev
drivers/target/target_core_device.c:175:24:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:176:25: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:176:25:    expected struct se_device *tmr_dev
drivers/target/target_core_device.c:176:25:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:219:21: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:219:21:    expected struct se_lun *lun
drivers/target/target_core_device.c:219:21:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:247:55: warning: incorrect type in argument 1 (different address spaces)
drivers/target/target_core_device.c:247:55:    expected struct se_lun *<noident>
drivers/target/target_core_device.c:247:55:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_device.c:335:34: error: incompatible types in comparison expression (different address spaces)
drivers/target/target_core_device.c:421:45: warning: incorrect type in argument 1 (different address spaces)
drivers/target/target_core_device.c:421:45:    expected struct se_device *<noident>
drivers/target/target_core_device.c:421:45:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:438:33: error: incompatible types in comparison expression (different address spaces)
drivers/target/target_core_device.c:519:6: warning: symbol 'se_dev_check_wce' was not declared. Should it be static?
drivers/target/target_core_device.c:643:48: warning: incorrect type in argument 1 (different address spaces)
drivers/target/target_core_device.c:643:48:    expected struct se_device *<noident>
drivers/target/target_core_device.c:643:48:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:793:31: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_device.c:793:31:    expected struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_device.c:793:31:    got struct se_device *[assigned] dev
  CC [M]  drivers/target/target_core_device.o
  CHECK   drivers/target/target_core_fabric_configfs.c
  CC [M]  drivers/target/target_core_fabric_configfs.o
  CHECK   drivers/target/target_core_fabric_lib.c
  CC [M]  drivers/target/target_core_fabric_lib.o
  CHECK   drivers/target/target_core_hba.c
  CC [M]  drivers/target/target_core_hba.o
  CHECK   drivers/target/target_core_pr.c
drivers/target/target_core_pr.c:1412:45: warning: incorrect type in initializer (different address spaces)
drivers/target/target_core_pr.c:1412:45:    expected struct se_lun_acl *lun_acl
drivers/target/target_core_pr.c:1412:45:    got struct se_lun_acl [noderef] <asn:4>*se_lun_acl
drivers/target/target_core_pr.c:1435:17: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_pr.c:1435:17:    expected struct se_lun_acl *lun_acl
drivers/target/target_core_pr.c:1435:17:    got struct se_lun_acl [noderef] <asn:4>*se_lun_acl
drivers/target/target_core_pr.c:763:67: warning: incorrect type in argument 3 (different address spaces)
drivers/target/target_core_pr.c:763:67:    expected struct se_lun *lun
drivers/target/target_core_pr.c:763:67:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_pr.c:1718:68: warning: incorrect type in argument 3 (different address spaces)
drivers/target/target_core_pr.c:1718:68:    expected struct se_lun *lun
drivers/target/target_core_pr.c:1718:68:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_pr.c:3419:53: warning: incorrect type in argument 3 (different address spaces)
drivers/target/target_core_pr.c:3419:53:    expected struct se_lun *lun
drivers/target/target_core_pr.c:3419:53:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_pr.c:719:44: warning: dereference of noderef expression
  CC [M]  drivers/target/target_core_pr.o
  CHECK   drivers/target/target_core_alua.c
drivers/target/target_core_alua.c:978:30: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_alua.c:978:30:    expected struct se_lun_acl *lacl
drivers/target/target_core_alua.c:978:30:    got struct se_lun_acl [noderef] <asn:4>*se_lun_acl
drivers/target/target_core_alua.c:1938:36: warning: incorrect type in initializer (different address spaces)
drivers/target/target_core_alua.c:1938:36:    expected struct se_device *dev
drivers/target/target_core_alua.c:1938:36:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_alua.c:2192:36: warning: incorrect type in initializer (different address spaces)
drivers/target/target_core_alua.c:2192:36:    expected struct se_device *dev
drivers/target/target_core_alua.c:2192:36:    got struct se_device [noderef] <asn:4>*lun_se_dev
  CC [M]  drivers/target/target_core_alua.o
  CHECK   drivers/target/target_core_tmr.c
  CC [M]  drivers/target/target_core_tmr.o
  CHECK   drivers/target/target_core_tpg.c
drivers/target/target_core_tpg.c:108:21: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_tpg.c:108:21:    expected struct se_device *dev
drivers/target/target_core_tpg.c:108:21:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_tpg.c:669:36: warning: incorrect type in initializer (different address spaces)
drivers/target/target_core_tpg.c:669:36:    expected struct se_device *dev
drivers/target/target_core_tpg.c:669:36:    got struct se_device [noderef] <asn:4>*lun_se_dev
  CC [M]  drivers/target/target_core_tpg.o
  CHECK   drivers/target/target_core_transport.c
  CC [M]  drivers/target/target_core_transport.o
  CHECK   drivers/target/target_core_sbc.c
  CC [M]  drivers/target/target_core_sbc.o
  CHECK   drivers/target/target_core_spc.c
drivers/target/target_core_spc.c:695:17: error: incompatible types in comparison expression (different address spaces)
  CC [M]  drivers/target/target_core_spc.o
  CHECK   drivers/target/target_core_ua.c
  CC [M]  drivers/target/target_core_ua.o
  CHECK   drivers/target/target_core_rd.c
  CC [M]  drivers/target/target_core_rd.o
  CHECK   drivers/target/target_core_stat.c
drivers/target/target_core_stat.c:549:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:549:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:549:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:565:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:565:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:565:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:595:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:595:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:595:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:668:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:668:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:668:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:684:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:684:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:684:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:839:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:839:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:839:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:879:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:879:13:    expected struct se_device *dev
drivers/target/target_core_stat.c:879:13:    got struct se_device [noderef] <asn:4>*lun_se_dev
drivers/target/target_core_stat.c:997:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:997:13:    expected struct se_lun *lun
drivers/target/target_core_stat.c:997:13:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_stat.c:1363:13: warning: incorrect type in assignment (different address spaces)
drivers/target/target_core_stat.c:1363:13:    expected struct se_lun *lun
drivers/target/target_core_stat.c:1363:13:    got struct se_lun [noderef] <asn:4>*se_lun
drivers/target/target_core_stat.c:999:52: warning: dereference of noderef expression
drivers/target/target_core_stat.c:1365:52: warning: dereference of noderef expression
  CC [M]  drivers/target/target_core_stat.o
  CHECK   drivers/target/target_core_xcopy.c
  CC [M]  drivers/target/target_core_xcopy.o
  LD [M]  drivers/target/target_core_mod.o
  CHECK   drivers/target/target_core_iblock.c
  CC [M]  drivers/target/target_core_iblock.o
  CHECK   drivers/target/target_core_file.c
  CC [M]  drivers/target/target_core_file.o
  CHECK   drivers/target/target_core_pscsi.c
  CC [M]  drivers/target/target_core_pscsi.o
  CHECK   drivers/target/iscsi/iscsi_target_parameters.c
  CC [M]  drivers/target/iscsi/iscsi_target_parameters.o
  CHECK   drivers/target/iscsi/iscsi_target_seq_pdu_list.c
  CC [M]  drivers/target/iscsi/iscsi_target_seq_pdu_list.o
  CHECK   drivers/target/iscsi/iscsi_target_auth.c
  CC [M]  drivers/target/iscsi/iscsi_target_auth.o
  CHECK   drivers/target/iscsi/iscsi_target_datain_values.c
  CC [M]  drivers/target/iscsi/iscsi_target_datain_values.o
  CHECK   drivers/target/iscsi/iscsi_target_device.c
  CC [M]  drivers/target/iscsi/iscsi_target_device.o
  CHECK   drivers/target/iscsi/iscsi_target_erl0.c
  CC [M]  drivers/target/iscsi/iscsi_target_erl0.o
  CHECK   drivers/target/iscsi/iscsi_target_erl1.c
  CC [M]  drivers/target/iscsi/iscsi_target_erl1.o
  CHECK   drivers/target/iscsi/iscsi_target_erl2.c
  CC [M]  drivers/target/iscsi/iscsi_target_erl2.o
  CHECK   drivers/target/iscsi/iscsi_target_login.c
  CC [M]  drivers/target/iscsi/iscsi_target_login.o
  CHECK   drivers/target/iscsi/iscsi_target_nego.c
  CC [M]  drivers/target/iscsi/iscsi_target_nego.o
  CHECK   drivers/target/iscsi/iscsi_target_nodeattrib.c
  CC [M]  drivers/target/iscsi/iscsi_target_nodeattrib.o
  CHECK   drivers/target/iscsi/iscsi_target_tmr.c
  CC [M]  drivers/target/iscsi/iscsi_target_tmr.o
  CHECK   drivers/target/iscsi/iscsi_target_tpg.c
  CC [M]  drivers/target/iscsi/iscsi_target_tpg.o
  CHECK   drivers/target/iscsi/iscsi_target_util.c
  CC [M]  drivers/target/iscsi/iscsi_target_util.o
  CHECK   drivers/target/iscsi/iscsi_target.c
  CC [M]  drivers/target/iscsi/iscsi_target.o
  CHECK   drivers/target/iscsi/iscsi_target_configfs.c
  CC [M]  drivers/target/iscsi/iscsi_target_configfs.o
  CHECK   drivers/target/iscsi/iscsi_target_stat.c
  CC [M]  drivers/target/iscsi/iscsi_target_stat.o
  CHECK   drivers/target/iscsi/iscsi_target_transport.c
  CC [M]  drivers/target/iscsi/iscsi_target_transport.o
  LD [M]  drivers/target/iscsi/iscsi_target_mod.o
  CHECK   drivers/target/loopback/tcm_loop.c
  CC [M]  drivers/target/loopback/tcm_loop.o
  CHECK   drivers/target/sbp/sbp_target.c
drivers/target/sbp/sbp_target.c:1909:21: warning: incorrect type in assignment (different address spaces)
drivers/target/sbp/sbp_target.c:1909:21:    expected struct se_device *dev
drivers/target/sbp/sbp_target.c:1909:21:    got struct se_device [noderef] <asn:4>*lun_se_dev
