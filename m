From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm80xx: Phy settings support for motherboard controller.
Date: Wed, 13 Apr 2016 14:24:54 +0300
Message-ID: <20160413112454.GA25247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31571 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbcDMLZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 07:25:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AnandKumar.Santhanam@pmcs.com
Cc: pmchba@pmcs.com, linux-scsi@vger.kernel.org

Hello Anand Kumar Santhanam,

The patch 279094079a44: "[SCSI] pm80xx: Phy settings support for
motherboard controller." from Sep 18, 2013, leads to the following
static checker warning:

	drivers/scsi/pm8001/pm80xx_hwi.c:4554 mpi_set_phy_profile_req()
	error: uninitialized symbol 'tag'.

drivers/scsi/pm8001/pm80xx_hwi.c
  4540  void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
  4541          u32 operation, u32 phyid, u32 length, u32 *buf)
  4542  {
  4543          u32 tag , i, j = 0;
  4544          int rc;
  4545          struct set_phy_profile_req payload;
  4546          struct inbound_queue_table *circularQ;
  4547          u32 opc = OPC_INB_SET_PHY_PROFILE;
  4548  
  4549          memset(&payload, 0, sizeof(payload));
  4550          rc = pm8001_tag_alloc(pm8001_ha, &tag);
  4551          if (rc)
  4552                  PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
                                                                  ^^^^^^^^^^^^
Yup.

  4553          circularQ = &pm8001_ha->inbnd_q_tbl[0];
  4554          payload.tag = cpu_to_le32(tag);
                                          ^^^
Using invalid tag.

  4555          payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  & 0xFF));
  4556          PM8001_INIT_DBG(pm8001_ha,
  4557                  pm8001_printk(" phy profile command for phy %x ,length is %d\n",
  4558                          payload.ppc_phyid, length));
  4559          for (i = length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
  4560                  payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
  4561                  j++;
  4562          }
  4563          rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
  4564          if (rc)
  4565                  pm8001_tag_free(pm8001_ha, tag);
  4566  }


regards,
dan carpenter
