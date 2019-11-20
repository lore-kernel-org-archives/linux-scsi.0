Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBC4C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869872240E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MA2RLsIJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfKTDU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:20:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 22:20:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK38vIT015343;
        Wed, 20 Nov 2019 03:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=CBZGuCH7KN5QtT2knJuGg+4vDRg9htNvwNztnaaygPY=;
 b=MA2RLsIJz14cvDkMn5895YCnR/dBl771uxnxfpr9sW/3fq6ybdsh/RZpxZtRxlWKUP8g
 v4qQR7h1G4zy/1GsrssVUNxw9DrpnUan8m9Ovkq4DLhuKLiTyn180oH9N1xEMP6y1dnp
 s59DFtQ/uZZHkSfbEIMcvP25h4UxXx6hFfTkzzuEWKFvT8tLzA28/Z7gX18COt4Vh7aL
 sQZutgGjRbBdunW87RNXpe7bVN+W8/kzuM0rtpffAuJft+ZQfrbajhOFB5UtMqxlgUfE
 o8595lab9hzarwzy2XM40iGE+Sb2FjI8Z0/81Ha5iUIKuAlEoTN20f5R4eGAS6BcEkjG eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wa92ptu22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:20:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK399wC181653;
        Wed, 20 Nov 2019 03:20:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wc0ahg926-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:20:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAK3KH6P010994;
        Wed, 20 Nov 2019 03:20:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 19:20:16 -0800
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, dgilbert@interlog.com
Subject: Re: [PATCH] scsi_debug: check if the max_queue parameter is valid
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191119154059.9440-1-mlombard@redhat.com>
Date:   Tue, 19 Nov 2019 22:20:14 -0500
In-Reply-To: <20191119154059.9440-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Tue, 19 Nov 2019 16:40:59 +0100")
Message-ID: <yq1d0dnfd3l.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Maurizio!

> Passing an invalid value to max_queue may cause memory corruption
> or kernel freeze.

Instead of dealing with each of these parameters individually, maybe it
would be a good idea to go through all the int parameters and identify
the ones that really should be unsigned? And then tweak their input
validators accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
