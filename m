Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1659C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB99661175
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhFRJRs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 05:17:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229819AbhFRJRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 05:17:48 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I9ApsX028628;
        Fri, 18 Jun 2021 09:15:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=q5v7U9KJIUwUwu0IP+WbKyL7I0HJstwVAo6WUVsvar0=;
 b=rNTOhwq3eD8qRSCiKoSQqhlkXXLvYvHDrsKb6znkKE9fEmJ5cbsPmR8xFhVX0E0IZhLv
 SO64jcThNN0jVr14VzAjWGdHgJUD0IxzMAaElwNhFz2ef8Xsxg4EU0a5PReFUZW3V1cE
 F7oWSuaVc4QV1RdRLWgyUx7sDXKgshTgr5CL+udqmzuhNl79nj/Hyt45JVohLEZUs5KR
 4EHrhfYOEPRzhOKJFkHRkRLTJYP+AzASLyc8cwn8R6+kO38l0K4CuJyuqN/m5h/JnWpA
 lUlhAC7Sao2LbNPiKK2AoR6Y8DzeDFBsgYoj2AuRtSF5gB3eeHKkNEhq4+8T7kA+1Oxg tg== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39770hd1x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:15:37 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15I9Fbti193284;
        Fri, 18 Jun 2021 09:15:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 396waxjqkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:15:37 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15I9Fa2s193272;
        Fri, 18 Jun 2021 09:15:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 396waxjqjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:15:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15I9FZnT030107;
        Fri, 18 Jun 2021 09:15:35 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 02:15:34 -0700
Date:   Fri, 18 Jun 2021 12:15:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: elx: libefc_sli: Populate and post different WQEs
Message-ID: <YMxh0h8S7SX08yXp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: 6ZX4ulNH-CnC5kSRU2u3I86zg0TwhPp8
X-Proofpoint-ORIG-GUID: 6ZX4ulNH-CnC5kSRU2u3I86zg0TwhPp8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 1628f5b4976f: "scsi: elx: libefc_sli: Populate and post
different WQEs" from Jun 1, 2021, leads to the following static
checker warning:

	drivers/scsi/elx/libefc_sli/sli4.c:2384 sli_xmit_els_rsp64_wqe()
	warn: AND to zero '0x20 & 0x0'

drivers/scsi/elx/libefc_sli/sli4.c
  2360                  els->flags2 |= SLI4_ELS_DBDE;
  2361          else
  2362                  els->flags2 |= SLI4_ELS_XBL;
  2363  
  2364          els->els_response_payload.bde_type_buflen =
  2365                  cpu_to_le32((SLI4_BDE_TYPE_VAL(64)) |
  2366                              (params->rsp_len & SLI4_BDE_LEN_MASK));
  2367          els->els_response_payload.u.data.low =
  2368                  cpu_to_le32(lower_32_bits(rsp->phys));
  2369          els->els_response_payload.u.data.high =
  2370                  cpu_to_le32(upper_32_bits(rsp->phys));
  2371  
  2372          els->els_response_payload_length = cpu_to_le32(params->rsp_len);
  2373  
  2374          els->xri_tag = cpu_to_le16(params->xri);
  2375  
  2376          els->class_byte |= SLI4_GENERIC_CLASS_CLASS_3;
  2377  
  2378          els->command = SLI4_WQE_ELS_RSP64;
  2379  
  2380          els->request_tag = cpu_to_le16(params->tag);
  2381  
  2382          els->ox_id = cpu_to_le16(params->ox_id);
  2383  
  2384          els->flags2 |= SLI4_ELS_IOD & SLI4_ELS_REQUEST64_DIR_WRITE;
                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is zero.  Maybe it should be BIT(0)?

  2385  
  2386          els->flags2 |= SLI4_ELS_QOSD;
  2387  
  2388          els->cmd_type_wqec = SLI4_ELS_REQUEST64_CMD_GEN;
  2389  
  2390          els->cq_id = cpu_to_le16(SLI4_CQ_DEFAULT);
  2391  
  2392          if (params->rpi_registered) {
  2393                  els->ct_byte |=
  2394                          SLI4_GENERIC_CONTEXT_RPI << SLI4_ELS_CT_OFFSET;
  2395                  els->context_tag = cpu_to_le16(params->rpi);
  2396                  return 0;
  2397          }
  2398  
  2399          els->ct_byte |= SLI4_GENERIC_CONTEXT_VPI << SLI4_ELS_CT_OFFSET;

regards,
dan carpenter
