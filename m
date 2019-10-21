Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4D7CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 18:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CE72086D
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 18:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJUSlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 14:41:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:24788 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUSlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 14:41:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 11:41:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="gz'50?scan'50,208,50";a="200522630"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 21 Oct 2019 11:41:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iMcce-0007HG-V5; Tue, 22 Oct 2019 02:41:40 +0800
Date:   Tue, 22 Oct 2019 02:41:30 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     kbuild-all@lists.01.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/24] wd33c93: use SCSI status
Message-ID: <201910220249.VgYvBxuJ%lkp@intel.com>
References: <20191021095322.137969-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qnu4x4mgqr66tzrq"
Content-Disposition: inline
In-Reply-To: <20191021095322.137969-4-hare@suse.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--qnu4x4mgqr66tzrq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hannes,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on v5.4-rc4 next-20191021]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/scsi-Revamp-result-values/20191022-004918
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: m68k-multi_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/scsi/wd33c93.c: In function 'wd33c93_intr':
>> drivers/scsi/wd33c93.c:1297:19: warning: passing argument 1 of 'set_host_byte' makes pointer from integer without a cast [-Wint-conversion]
        set_host_byte(cmd->result, DID_ERROR);
                      ^~~
   In file included from drivers/scsi/wd33c93.c:79:0:
   include/scsi/scsi_cmnd.h:315:20: note: expected 'struct scsi_cmnd *' but argument is of type 'int'
    static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
                       ^~~~~~~~~~~~~

vim +/set_host_byte +1297 drivers/scsi/wd33c93.c

  1200	
  1201		case CSR_SDP:
  1202			DB(DB_INTR, printk("SDP"))
  1203			    hostdata->state = S_RUNNING_LEVEL2;
  1204			write_wd33c93(regs, WD_COMMAND_PHASE, 0x41);
  1205			write_wd33c93_cmd(regs, WD_CMD_SEL_ATN_XFER);
  1206			spin_unlock_irqrestore(&hostdata->lock, flags);
  1207			break;
  1208	
  1209		case CSR_XFER_DONE | PHS_MESS_OUT:
  1210		case CSR_UNEXP | PHS_MESS_OUT:
  1211		case CSR_SRV_REQ | PHS_MESS_OUT:
  1212			DB(DB_INTR, printk("MSG_OUT="))
  1213	
  1214	/* To get here, we've probably requested MESSAGE_OUT and have
  1215	 * already put the correct bytes in outgoing_msg[] and filled
  1216	 * in outgoing_len. We simply send them out to the SCSI bus.
  1217	 * Sometimes we get MESSAGE_OUT phase when we're not expecting
  1218	 * it - like when our SDTR message is rejected by a target. Some
  1219	 * targets send the REJECT before receiving all of the extended
  1220	 * message, and then seem to go back to MESSAGE_OUT for a byte
  1221	 * or two. Not sure why, or if I'm doing something wrong to
  1222	 * cause this to happen. Regardless, it seems that sending
  1223	 * NOP messages in these situations results in no harm and
  1224	 * makes everyone happy.
  1225	 */
  1226			    if (hostdata->outgoing_len == 0) {
  1227				hostdata->outgoing_len = 1;
  1228				hostdata->outgoing_msg[0] = NOP;
  1229			}
  1230			transfer_pio(regs, hostdata->outgoing_msg,
  1231				     hostdata->outgoing_len, DATA_OUT_DIR, hostdata);
  1232			DB(DB_INTR, printk("%02x", hostdata->outgoing_msg[0]))
  1233			    hostdata->outgoing_len = 0;
  1234			hostdata->state = S_CONNECTED;
  1235			spin_unlock_irqrestore(&hostdata->lock, flags);
  1236			break;
  1237	
  1238		case CSR_UNEXP_DISC:
  1239	
  1240	/* I think I've seen this after a request-sense that was in response
  1241	 * to an error condition, but not sure. We certainly need to do
  1242	 * something when we get this interrupt - the question is 'what?'.
  1243	 * Let's think positively, and assume some command has finished
  1244	 * in a legal manner (like a command that provokes a request-sense),
  1245	 * so we treat it as a normal command-complete-disconnect.
  1246	 */
  1247	
  1248	/* Make sure that reselection is enabled at this point - it may
  1249	 * have been turned off for the command that just completed.
  1250	 */
  1251	
  1252			write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
  1253			if (cmd == NULL) {
  1254				printk(" - Already disconnected! ");
  1255				hostdata->state = S_UNCONNECTED;
  1256				spin_unlock_irqrestore(&hostdata->lock, flags);
  1257				return;
  1258			}
  1259			DB(DB_INTR, printk("UNEXP_DISC"))
  1260			    hostdata->connected = NULL;
  1261			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
  1262			hostdata->state = S_UNCONNECTED;
  1263			if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
  1264				set_host_byte(cmd, DID_ERROR);
  1265			else
  1266				cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
  1267			cmd->scsi_done(cmd);
  1268	
  1269	/* We are no longer connected to a target - check to see if
  1270	 * there are commands waiting to be executed.
  1271	 */
  1272			/* look above for comments on scsi_done() */
  1273			spin_unlock_irqrestore(&hostdata->lock, flags);
  1274			wd33c93_execute(instance);
  1275			break;
  1276	
  1277		case CSR_DISC:
  1278	
  1279	/* Make sure that reselection is enabled at this point - it may
  1280	 * have been turned off for the command that just completed.
  1281	 */
  1282	
  1283			write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
  1284			DB(DB_INTR, printk("DISC"))
  1285			    if (cmd == NULL) {
  1286				printk(" - Already disconnected! ");
  1287				hostdata->state = S_UNCONNECTED;
  1288			}
  1289			switch (hostdata->state) {
  1290			case S_PRE_CMP_DISC:
  1291				hostdata->connected = NULL;
  1292				hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
  1293				hostdata->state = S_UNCONNECTED;
  1294				DB(DB_INTR, printk(":%d", cmd->SCp.Status));
  1295				if (cmd->cmnd[0] == REQUEST_SENSE
  1296				    && cmd->SCp.Status != SAM_STAT_GOOD)
> 1297					set_host_byte(cmd->result, DID_ERROR);
  1298				else
  1299					cmd->result =
  1300					    cmd->SCp.Status | (cmd->SCp.Message << 8);
  1301				cmd->scsi_done(cmd);
  1302				break;
  1303			case S_PRE_TMP_DISC:
  1304			case S_RUNNING_LEVEL2:
  1305				cmd->host_scribble = (uchar *) hostdata->disconnected_Q;
  1306				hostdata->disconnected_Q = cmd;
  1307				hostdata->connected = NULL;
  1308				hostdata->state = S_UNCONNECTED;
  1309	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--qnu4x4mgqr66tzrq
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
UxMN/wfB2/oZE+gAAA==

--qnu4x4mgqr66tzrq--
