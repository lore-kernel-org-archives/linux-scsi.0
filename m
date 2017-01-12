From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: Reinstate lpfc_soft_wwn parameter
Date: Fri, 13 Jan 2017 00:08:04 +0300
Message-ID: <20170112210804.GA19275@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35089 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdALVIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 16:08:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 352e5fd10598: "scsi: lpfc: Reinstate lpfc_soft_wwn
parameter" from Dec 30, 2016, leads to the following static checker
warning:

	drivers/scsi/lpfc/lpfc_attr.c:2156 lpfc_soft_wwpn_store()
	info: return a literal instead of 'rc'

drivers/scsi/lpfc/lpfc_attr.c
  2146          if (!phba->soft_wwn_enable)
  2147                  return -EINVAL;
  2148  
  2149          /* lock setting wwpn, wwnn down */
  2150          phba->soft_wwn_enable = 0;
  2151  
  2152          rc = lpfc_wwn_set(buf, cnt, wwpn);
  2153          if (!rc) {
  2154                  /* not able to set wwpn, unlock it */
  2155                  phba->soft_wwn_enable = 1;
  2156                  return rc;

lpfc_wwn_set() returns zero when we are able to set wwpn so, from the
comment, i suspect that the if statement is reversed.  There was a
similar thing in lpfc_soft_wwnn_store() as well.

  2157          }
  2158  
  2159          phba->cfg_soft_wwpn = wwn_to_u64(wwpn);
  2160          fc_host_port_name(shost) = phba->cfg_soft_wwpn;
  2161          if (phba->cfg_soft_wwnn)
  2162                  fc_host_node_name(shost) = phba->cfg_soft_wwnn;
  2163  
  2164          dev_printk(KERN_NOTICE, &phba->pcidev->dev,
  2165                     "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
  2166  

regards,
dan carpenter
