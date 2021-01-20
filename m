Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF26C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B0023139
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbhATL0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54094 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388718AbhATLAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 06:00:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KAwYk0126201;
        Wed, 20 Jan 2021 10:59:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=L0pyxJAGnnyAYInsBTxme+7a3xGS0tmHVziE0hbwqAc=;
 b=IhnVIpI3Dn3pckx9kFgGYulXLewBXmS2bYH4PBl+fNbXSgh7qpvMEY+vR8iLsqCFPpHo
 0JinWxjoJuP4b1d6YFb81oTjK/uFcRodYhZZkxo3GLJXZ7+A6XnObUvaYoObeptsaeWA
 L4fHArV/2HIK61uRHAJGQlh11+1hsHTc6yyIdJ7TrtCH0GO24Y5GsModJPmc0hez9NLV
 emQvbmBxw7AuKHijSFry5K+K2mtUUOPM9xbL3gZE/fE1sjN7dcCdTcCKGuAOpqiANZhY
 VIS+VrBR/3Qrq2BVqFJ0eMPuILjJ9oH3DbZMymlW8PUFd1gK0m8gajZdXRZjAUJlzGHO mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3668qr9wht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 10:59:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KApgQk167108;
        Wed, 20 Jan 2021 10:57:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3668rcuybf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 10:57:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10KAvpSG017847;
        Wed, 20 Jan 2021 10:57:51 GMT
Received: from mwanda (/10.175.34.136)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Jan 2021 02:57:51 -0800
Date:   Wed, 20 Jan 2021 13:57:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     qutran@marvell.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: qla2xxx: Fix SRB leak on switch command timeout
Message-ID: <YAgMqa2/7ugeBKVW@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=980 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=923 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200064
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Quinn Tran,

The patch af2a0c51b120: "scsi: qla2xxx: Fix SRB leak on switch
command timeout" from Nov 5, 2019, leads to the following static
checker warning:

	drivers/scsi/qla2xxx/qla_os.c:1032 qla2xxx_mqueuecommand()
	error: dereferencing freed memory 'sp'

drivers/scsi/qla2xxx/qla_os.c
  1020  
  1021          return 0;
  1022  
  1023  qc24_host_busy_free_sp:
  1024          sp->free(sp);
  1025  
  1026  qc24_target_busy:
  1027          return SCSI_MLQUEUE_TARGET_BUSY;
  1028  
  1029  qc24_free_sp_fail_command:
  1030          sp->free(sp);
  1031          CMD_SP(cmd) = NULL;
  1032          qla2xxx_rel_qpair_sp(sp->qpair, sp);

This seems like potentially a false positive but the code is weird.
In this case we know that ->free is qla2xxx_qpair_sp_free_dma().

Smatch isn't making that connection and it complains that half the
free functions call qla2xxx_rel_qpair_sp() and half don't.  These three
free "sp"

qla2x00_sp_free()
qla2x00_els_dcmd_sp_free()
qla2x00_bsg_sp_free()

The free functions which don't free "sp" are:

qla2x00_sp_free_dma()
qla2xxx_qpair_sp_free_dma()
qla2xxx_rel_free_warning()

  1033  
  1034  qc24_fail_command:
  1035          cmd->scsi_done(cmd);
  1036  
  1037          return 0;
  1038  }

regards,
dan carpenter
