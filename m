Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB88C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 05:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB21214DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 05:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d6MepNOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfKHFRs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:17:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfKHFRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 00:17:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA85EmAB183636;
        Fri, 8 Nov 2019 05:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=UpiWvQdNrminQVYr/zu1Zl4J3+/dw9rl5nBD5r3vYzM=;
 b=d6MepNObw/2OHAG1rvEngweCwn1izD93LKTabSqncj5Qe9SdlL4G4WDZ9co5XtgAGFjZ
 smA9tnh1NszYMQaTGfYUXP6Sjk16mNZHSUUu//XZA7OREOn+8bH7KyaFEcn/gSPCI+XV
 VmymXXBpyWiYOAth6eMk0/R4mQJ3KWDUPVc2vt3XuPT3wmXKnAHviXwehEvALydFScA1
 LJdn1iP0iJ1ZEIrvc2XdsFdNy2N80yH50yZM2Ub6Mpdo/wbWOQgxAeWPBVRypsptBcir
 6A0s7rvoXwIckew5LSJrl1MhEEuMvM6f57oTe+jiX9kzfA3TBhs4+WjdMJIiQH/yC/9A JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w1ay8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:17:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA85Ei3q025674;
        Fri, 8 Nov 2019 05:17:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41wbqk9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:17:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA85HiIQ005874;
        Fri, 8 Nov 2019 05:17:44 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 21:17:44 -0800
Date:   Fri, 8 Nov 2019 08:17:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Add registration for CPU Offline/Online
 events
Message-ID: <20191108051738.GA27223@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=48 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=80 spamscore=0 clxscore=1011
 lowpriorityscore=80 mlxscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080051
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 93a4d6f40198: "scsi: lpfc: Add registration for CPU
Offline/Online events" from Nov 4, 2019, leads to the following
Smatch complaint:

    drivers/scsi/lpfc/lpfc_init.c:11873 lpfc_sli4_hba_unset()
    warn: variable dereferenced before check 'phba->pport' (see line 11844)

drivers/scsi/lpfc/lpfc_init.c
 11843		/* per-phba callback de-registration for hotplug event */
 11844		lpfc_cpuhp_remove(phba);
                                  ^^^^
New dereference of "phba->pport" inside this function.

 11845	
 11846		/* Disable PCI subsystem interrupt */
 11847		lpfc_sli4_disable_intr(phba);
 11848	
 11849		/* Disable SR-IOV if enabled */
 11850		if (phba->cfg_sriov_nr_virtfn)
 11851			pci_disable_sriov(pdev);
 11852	
 11853		/* Stop kthread signal shall trigger work_done one more time */
 11854		kthread_stop(phba->worker_thread);
 11855	
 11856		/* Disable FW logging to host memory */
 11857		lpfc_ras_stop_fwlog(phba);
 11858	
 11859		/* Unset the queues shared with the hardware then release all
 11860		 * allocated resources.
 11861		 */
 11862		lpfc_sli4_queue_unset(phba);
 11863		lpfc_sli4_queue_destroy(phba);
 11864	
 11865		/* Reset SLI4 HBA FCoE function */
 11866		lpfc_pci_function_reset(phba);
 11867	
 11868		/* Free RAS DMA memory */
 11869		if (phba->ras_fwlog.ras_enabled)
 11870			lpfc_sli4_ras_dma_free(phba);
 11871	
 11872		/* Stop the SLI4 device port */
 11873		if (phba->pport)
                    ^^^^^^^^^^^
The old code used to check for NULL.

 11874			phba->pport->work_port_events = 0;
 11875	}

regards,
dan carpenter
