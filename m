Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AE2C63777
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 11:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3609B208B3
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 11:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aPu9/Guj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgK0LAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 06:00:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgK0LAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2020 06:00:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ARAxv52141876;
        Fri, 27 Nov 2020 10:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=WRtae3gKj0iTjLgLYrvkDJuuB0EzlMrtrhFbIV5YCcg=;
 b=aPu9/GujZrUwePfyXnIBx0qUENJFwvSy6Dr8SCHQRyf2BiCe+aORV9w6C/WayMaeXY/Z
 zNdO5QXBIoL6j6YdwqGxBOc0YxQoktM6c7hMJG0ALo+bF+0js3WF4V8LlDg6i/NR+Rq+
 EY+CtpCPVgGyHZQgqdWSouzAPj3cK6TjhCAPOJIH4Uh+GRk6n2+gmATFlByWAUlOIyzi
 oxZD5a3OQ3gIHVtfs0TkxTN/zSHypPVAVlanAdnLPY35KHaF3Jn9K+8HDLHReCXY8oGN
 VBl2zsee5cymszJKeBlWaROcyz2/bhBnno3PHVSbaF9kf6sr7sn/ISfOvbzfFK2G5Me6 Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 351kwhgwf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 27 Nov 2020 10:59:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ARAoFMD060618;
        Fri, 27 Nov 2020 10:59:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 351n2m78y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 10:59:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ARAxufJ001631;
        Fri, 27 Nov 2020 10:59:56 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Nov 2020 01:54:58 -0800
Date:   Fri, 27 Nov 2020 12:54:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     james.smart@broadcom.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Rework locations of ndlp reference taking
Message-ID: <20201127095450.GA10080@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9817 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9817 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=3 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011270068
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 4430f7fd09ec: "scsi: lpfc: Rework locations of ndlp 
reference taking" from Nov 15, 2020, leads to the following Smatch 
complaint:

    drivers/scsi/lpfc/lpfc_els.c:2043 lpfc_cmpl_els_plogi()
    error: we previously assumed 'ndlp' could be null (see line 1942)

drivers/scsi/lpfc/lpfc_els.c
  1941		ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
  1942		if (!ndlp) {
                     ^^^^
  1943			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
  1944					 "0136 PLOGI completes to NPort x%x "
  1945					 "with no ndlp. Data: x%x x%x x%x\n",
  1946					 irsp->un.elsreq64.remoteID,
  1947					 irsp->ulpStatus, irsp->un.ulpWord[4],
  1948					 irsp->ulpIoTag);
  1949			goto out;
                        ^^^^^^^^
"ndlp" is NULL

  1950		}
  1951	
  1952		/* Since ndlp can be freed in the disc state machine, note if this node
  1953		 * is being used during discovery.
  1954		 */
  1955		spin_lock_irq(&ndlp->lock);
  1956		disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
  1957		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
  1958		spin_unlock_irq(&ndlp->lock);
  1959	
  1960		/* PLOGI completes to NPort <nlp_DID> */
  1961		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
  1962				 "0102 PLOGI completes to NPort x%06x "
  1963				 "Data: x%x x%x x%x x%x x%x\n",
  1964				 ndlp->nlp_DID, ndlp->nlp_fc4_type,
  1965				 irsp->ulpStatus, irsp->un.ulpWord[4],
  1966				 disc, vport->num_disc_nodes);
  1967	
  1968		/* Check to see if link went down during discovery */
  1969		if (lpfc_els_chk_latt(vport)) {
  1970			spin_lock_irq(&ndlp->lock);
  1971			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
  1972			spin_unlock_irq(&ndlp->lock);
  1973			goto out;
  1974		}
  1975	
  1976		if (irsp->ulpStatus) {
  1977			/* Check for retry */
  1978			if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
  1979				/* ELS command is being retried */
  1980				if (disc) {
  1981					spin_lock_irq(&ndlp->lock);
  1982					ndlp->nlp_flag |= NLP_NPR_2B_DISC;
  1983					spin_unlock_irq(&ndlp->lock);
  1984				}
  1985				goto out;
  1986			}
  1987			/* PLOGI failed Don't print the vport to vport rjts */
  1988			if (irsp->ulpStatus != IOSTAT_LS_RJT ||
  1989				(((irsp->un.ulpWord[4]) >> 16 != LSRJT_INVALID_CMD) &&
  1990				((irsp->un.ulpWord[4]) >> 16 != LSRJT_UNABLE_TPC)) ||
  1991				(phba)->pport->cfg_log_verbose & LOG_ELS)
  1992				lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
  1993					 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
  1994					 ndlp->nlp_DID, irsp->ulpStatus,
  1995					 irsp->un.ulpWord[4]);
  1996	
  1997			/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
  1998			if (lpfc_error_lost_link(irsp))
  1999				goto check_plogi;
  2000			else
  2001				lpfc_disc_state_machine(vport, ndlp, cmdiocb,
  2002							NLP_EVT_CMPL_PLOGI);
  2003	
  2004			/* As long as this node is not registered with the scsi or nvme
  2005			 * transport, it is no longer an active node.  Otherwise
  2006			 * devloss handles the final cleanup.
  2007			 */
  2008			if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
  2009				spin_lock_irq(&ndlp->lock);
  2010				ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
  2011				spin_unlock_irq(&ndlp->lock);
  2012				lpfc_disc_state_machine(vport, ndlp, cmdiocb,
  2013							NLP_EVT_DEVICE_RM);
  2014			}
  2015		} else {
  2016			/* Good status, call state machine */
  2017			prsp = list_entry(((struct lpfc_dmabuf *)
  2018					   cmdiocb->context2)->list.next,
  2019					  struct lpfc_dmabuf, list);
  2020			ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
  2021			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
  2022						NLP_EVT_CMPL_PLOGI);
  2023		}
  2024	
  2025	 check_plogi:
  2026		if (disc && vport->num_disc_nodes) {
  2027			/* Check to see if there are more PLOGIs to be sent */
  2028			lpfc_more_plogi(vport);
  2029	
  2030			if (vport->num_disc_nodes == 0) {
  2031				spin_lock_irq(shost->host_lock);
  2032				vport->fc_flag &= ~FC_NDISC_ACTIVE;
  2033				spin_unlock_irq(shost->host_lock);
  2034	
  2035				lpfc_can_disctmo(vport);
  2036				lpfc_end_rscn(vport);
  2037			}
  2038		}
  2039	
  2040	out:
  2041		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
  2042				      "PLOGI Cmpl PUT:     did:x%x refcnt %d",
  2043				      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
                                      ^^^^^^^^^^^^^            ^^^^^^^^^^^
Dereferenced here.

  2044	
  2045		/* Release the reference on the original I/O request. */

regards,
dan carpenter
