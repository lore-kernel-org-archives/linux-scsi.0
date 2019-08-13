Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FF3C31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E67620673
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LJPkwiQJ";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b6GbxQIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfHMCFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 22:05:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHMCFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 22:05:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D24ET0030347;
        Tue, 13 Aug 2019 02:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=TD2l+ifzH1wr/vfxIsIriVfG2KriPDSqy2pRR3pF78Y=;
 b=LJPkwiQJK6mFkLF2mweT/Riud5BugaZapaLYGQyIdvQFZn5GpCzuNhXlmCEnuh9R8bdO
 /IOg5Gi4u7g3nP3heyOYN/t9beCpjoOw5kZ9hqBekmcEt1sifCCeA7hg5fxJHHeRyucP
 WCuW9F1+4f47nytOIjiFcBAG5jZOk7MEYjB1PFYw0m9+TWrBi4PrgaaEImKMJCVglxz9
 2YaJdkHVsrr+Z2rGD3Fk2YXo+H8WpGB81hjeYlbCTTTB5I62RhLVckUOiQ8UPB90QBAO
 BBdC1WxDf+cfXC3wnzZau9OaNVfV20N0PKqK4ZV+u4lFgGv2DeTAQct+NhkVQZe8jLxo zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=TD2l+ifzH1wr/vfxIsIriVfG2KriPDSqy2pRR3pF78Y=;
 b=b6GbxQINtISvUCKBFrwLsTTjQX/dHb6QnZCjwSzD3zU6jWPE2wQAHKH+JrPTEyVnkp/4
 +C6dyxUljzvdAdKkJJT8orhkGZMR9y7MaJxHWNycyWG+UJkoXsYG7jbEHO3fiLfFnBya
 h+fRWXnmtqO8nMgWUxSbVWPaEdbv2yR59Sxbk2z3i02LZ2QT3te3MjX/Rfrt76bpvevH
 kbXHAMP7oN6eBizLRkQzHUdeGRx4/WJwp1o/U6p8ncscgZUIiZ6AfTyc+86gY0SCZ7vw
 tVmuhbjfGU2KC23LHAg8P9yhzgtaH/vE6FHctITWHINcPQyO2qiizbYt9HnmiXsnjkpR Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u9pjqb0e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:05:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D22kVY104451;
        Tue, 13 Aug 2019 02:05:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u9k1vwj5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:05:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D256sP020905;
        Tue, 13 Aug 2019 02:05:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 19:05:06 -0700
To:     Frederick Lawler <fred@fredlawl.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [PATCH] scsi: esas2r: Prefer pcie_capability_read_word()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190718020745.8867-1-fred@fredlawl.com>
        <20190718020745.8867-9-fred@fredlawl.com>
Date:   Mon, 12 Aug 2019 22:05:01 -0400
In-Reply-To: <20190718020745.8867-9-fred@fredlawl.com> (Frederick Lawler's
        message of "Wed, 17 Jul 2019 21:07:44 -0500")
Message-ID: <yq1v9v17rci.fsf@oracle.com>
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
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
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
> need to be aware of differences between v1 and v2 of the PCI
> Express Capability.
>
> Replace pci_read_config_word() and pci_write_config_word() calls with
> pcie_capability_read_word() and pcie_capability_write_word().

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
