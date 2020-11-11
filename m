Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB1C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8512620825
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tnSA1P6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKKEI5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:08:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgKKEI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 23:08:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB449we090305;
        Wed, 11 Nov 2020 04:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IVxKlKj2u2ChwvH87FLPmfUzdGcvNuupnV6Etx+4L2c=;
 b=tnSA1P6JZG5aky81G1J+ykQ/N9u1yIt0sseg6hbum5KJoSShuhxBKCj5FM/Ajc4RS6ib
 Ofein/eRh6lrZNrqkN3yYBzb4YJP6cfuZr1RCZ58D0D954T2UEWQ8RLCcoWurLxnHOmj
 NES+zTOj2yeJ5aE1o49bl90ugfevbGehtrZ8No+BF3iwgWVtLg7IK7fxSH9+IFRtSeWW
 SEoMHXf0yzxv+uQvfSs00T+gGl5nLIECPD/LhilYFNrR1PtU9Ozg1j3E4Uu7hGlJPnKV
 sAkIK/xVXjlHU7LSUZ93wzkunooOrFaP0gLES417CVX+By/miqaxAGuEufxRHI3qEqRG vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhky21w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 04:08:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB41DAx018273;
        Wed, 11 Nov 2020 04:08:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55pf53g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 04:08:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB48nZk004797;
        Wed, 11 Nov 2020 04:08:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 20:08:49 -0800
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Intel SCU Linux support <intel-linux-scu@intel.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: isci: Don't use PCI helper functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blg4fsc6.fsf@ca-mkp.ca.oracle.com>
References: <20201107100420.149521-1-vaibhavgupta40@gmail.com>
Date:   Tue, 10 Nov 2020 23:08:47 -0500
In-Reply-To: <20201107100420.149521-1-vaibhavgupta40@gmail.com> (Vaibhav
        Gupta's message of "Sat, 7 Nov 2020 15:34:19 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=828 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=842 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Vaibhav,

> PCI helper functions such as pci_enable/disable_device(),
> pci_save/restore_state(), pci_set_power_state(), etc. were used by the
> legacy framework to perform standard operations related to PCI PM.
>
> This driver is using the generic framework and thus calls for those
> functions should be dropped as those tasks are now performed by the PCI
> core.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
