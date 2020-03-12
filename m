Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2922EC0044D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47ACD2074E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WHSH2VRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgCLDJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:09:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 23:09:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C39ZQP125574;
        Thu, 12 Mar 2020 03:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=tEGWsB+R0I+MlqaRusvVYzBPH4pGXMA7VnbYNzFRYhk=;
 b=WHSH2VRItQ2T0kZzCE/aBepyYIE2X2hS1LPd+/WexEujROBnKJOy+H3W9IrMmXUZl3lB
 VZ3/dKvqHEHyHleGCUMhcvsibaQtww8Y0CndwQ5AxmX7avQA+aOWyU0uFt26ZPbA+37N
 NV7ISg8KUsjpQRuzbdoVLEEUphjDVBHxxTZbFSoQgp8269eQdocHxEKr1HvNIyFacxUA
 ua1+Ueeq5K02rwiHf+58PSsKXIHB0H08iqLkc/x1K/GFw0bd17L0cfV1rngR/Gc3lQMC
 GtzgfmDAkfmnTBnipBccI+qcxPTaDBxAhTeR83L1hpYLJS6VcqHZVo0azho/rVAKnZOn 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yp9v6a6xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:09:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C384iP096160;
        Thu, 12 Mar 2020 03:09:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ypv9wuhgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:09:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C39qnj022638;
        Thu, 12 Mar 2020 03:09:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:09:52 -0700
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: avoid repetitive logging of device offline messages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200311143930.20674-1-emilne@redhat.com>
Date:   Wed, 11 Mar 2020 23:09:50 -0400
In-Reply-To: <20200311143930.20674-1-emilne@redhat.com> (Ewan D. Milne's
        message of "Wed, 11 Mar 2020 10:39:30 -0400")
Message-ID: <yq1wo7q9sld.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

> Large queues of I/O to offline devices that are eventually submitted
> when devices are unblocked result in a many repeated "rejecting I/O to
> offline device" messages.  These messages can fill up the dmesg buffer
> in crash dumps so no useful prior messages remain.  In addition, if a
> serial console is used, the flood of messages can cause a hard lockup
> in the console code.
>
> Introduce a flag indicating the message has already been logged for
> the device, and reset the flag when scsi_device_set_state() changes
> the device state.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
