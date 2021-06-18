Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A7FC48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 05:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6C961351
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 05:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFRFbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 01:31:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26468 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232467AbhFRFbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 01:31:04 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I5B23e021392;
        Fri, 18 Jun 2021 05:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MKhEPkB2SaYH/nABVa56qqWJyIm4bOLPdi5GcXPHISc=;
 b=KR+F7UeU/2Ufff+Fnr6cfZhdoFEhtBMvJp6LyCPHR38Xb4j2WW5cO1XnniYB7pKbasKp
 clObbK1AfYEqwg3dxln5qnCzjoyfrUOpyARVN0ZeS+uUNhcCA+kM1Le+z01XCh0d4UsS
 ua9gQG7lmqitKa5fNsD2NFOAte3plY4N7sG7n9/WAIcod8cbXMfp0kazxnr05CoIXRQ0
 lUlP5VtVv96TKL8RfoodJYSheZWS1jg83tXXvVNieD2pkhW0QPGJZu8giWV5g0zvZT6Z
 4/IwaGLCTVB+lBGOFrFj1LzGIP7KrYDhIlnONEeuUPWqfw7Yse+i7oTsVZKSQSmaOAu0 bQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39770hcn26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:28:54 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15I5PjXr031582;
        Fri, 18 Jun 2021 05:28:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 396wayg8w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:28:53 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15I5SrjZ041468;
        Fri, 18 Jun 2021 05:28:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 396wayg8w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:28:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15I5SqC7017938;
        Fri, 18 Jun 2021 05:28:52 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jun 2021 22:28:51 -0700
Date:   Fri, 18 Jun 2021 08:28:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: elx: efct: LIO backend interface routines
Message-ID: <YMwvDl71G6IWHUWN@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: cxmvViunF94HdFksWMyN9oCard7oBMnv
X-Proofpoint-ORIG-GUID: cxmvViunF94HdFksWMyN9oCard7oBMnv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 692e5d73a811: "scsi: elx: efct: LIO backend interface
routines" from Jun 1, 2021, leads to the following static checker
warning:

	drivers/scsi/elx/efct/efct_lio.c:851 efct_lio_npiv_make_nport()
	warn: '&vport_list->list_entry' not removed from list

drivers/scsi/elx/efct/efct_lio.c
   828          vport_list = kzalloc(sizeof(*vport_list), GFP_KERNEL);
   829          if (!vport_list) {
   830                  kfree(lio_vport);
   831                  return ERR_PTR(-ENOMEM);
   832          }
   833  
   834          vport_list->lio_vport = lio_vport;
   835          spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
   836          INIT_LIST_HEAD(&vport_list->list_entry);
   837          list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
                               ^^^^^^^^^^^^^^^^^^^^^^
Is it possible to add this to the list after fc_vport_create() succeeds?

   838          spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
   839  
   840          memset(&vport_id, 0, sizeof(vport_id));
   841          vport_id.port_name = npiv_wwpn;
   842          vport_id.node_name = npiv_wwnn;
   843          vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
   844          vport_id.vport_type = FC_PORTTYPE_NPIV;
   845          vport_id.disable = false;
   846  
   847          new_fc_vport = fc_vport_create(efct->shost, 0, &vport_id);
   848          if (!new_fc_vport) {
   849                  efc_log_err(efct, "fc_vport_create failed\n");
   850                  kfree(lio_vport);
   851                  kfree(vport_list);

In the corrent code we free it without removing it from the list which
leads to a use after free.

   852                  return ERR_PTR(-ENOMEM);
   853          }
   854  
   855          lio_vport->fc_vport = new_fc_vport;
   856  
   857          return &lio_vport->vport_wwn;
   858  }

regards,
dan carpenter
