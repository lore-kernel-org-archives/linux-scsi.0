Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EEDC31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE8F20673
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kFX4bDhi";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pksk+lP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfHMCE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 22:04:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHMCE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 22:04:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D24p1b044971;
        Tue, 13 Aug 2019 02:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SkNfOmQlVAAGz9izLbKRzBlPo2QJu4z2YTrCBIP/Fqk=;
 b=kFX4bDhiO2wlkpeGF9S/E+ODGTfpHdu6/nMYXb3qYis3ap6ITD+tUsBAXf4LuF9qKAV3
 s/RDdHSz9EBuGUowH2gsRkaB8Mz/8fLAravLYyS2MiYZ4BANcSkzPg9VvQnhwtD0fuHW
 TShCoVw4CiSA6O9GCQKgTiH5Njocj11YxyGLd8ICUC1vN+zos1Gb3R+1QlawYvTiKZHM
 4fZi4jJSfV10yYr4o6d2K1uAUhxQuufLdnepqXHLxzMBiugmiPdk8rv/p99HXohxxQ+b
 CyL4w6TAh2fC5ayk6D0JlddPJtkfMchSla8hXZtNx80nyfr+bWHXkIvwrYxi1xK2oY5C Zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=SkNfOmQlVAAGz9izLbKRzBlPo2QJu4z2YTrCBIP/Fqk=;
 b=pksk+lP2yfp3DJ6S5Kzus+suq8MVKfmUdTyiOQvbh+4xgNrxF4mXlw/Uqmw9CgwMxIhz
 TKLe7FvAxPYOZAsyS5/ZyoCx08L13aso2hQGWNCb8nP11p+t+oIBcsdBHdLZZ/17TCwo
 dpuoJ0AY8KA4dFtlArjnNxf0ZCkNQnjBmlCfFcZYuBghG6WM1hvBJ9ioF5fNK0jP5WU1
 i7GiA8GbZkSRS0mpQ3HdpNCbxnlwovbrA1vUyLaVe2VDScgs8EPlR5CGaTgsJvazYF1O
 +gCXBo4UMeF3iYXXi958yhLtIvqfLEgube6TfHuWq+lFqEJgJkmt0VdNDla1VG0B/jmq Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u9nvp342j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:04:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D23f0J185587;
        Tue, 13 Aug 2019 02:04:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u9m0assaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:04:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D24oXV020566;
        Tue, 13 Aug 2019 02:04:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 19:04:49 -0700
To:     Frederick Lawler <fred@fredlawl.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [PATCH] scsi: csiostor: Prefer pcie_capability_read_word()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190718020745.8867-1-fred@fredlawl.com>
        <20190718020745.8867-8-fred@fredlawl.com>
Date:   Mon, 12 Aug 2019 22:04:47 -0400
In-Reply-To: <20190718020745.8867-8-fred@fredlawl.com> (Frederick Lawler's
        message of "Wed, 17 Jul 2019 21:07:43 -0500")
Message-ID: <yq1zhkd7rcw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=731
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=788 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Frederick,

> Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
> added accessors for the PCI Express Capability so that drivers didn't
> need to be aware of differences between v1 and v2 of the PCI Express
> Capability.
>
> Replace pci_read_config_word() and pci_write_config_word() calls with
> pcie_capability_read_word() and pcie_capability_write_word().

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
