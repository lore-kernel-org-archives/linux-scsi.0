Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE01C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiBODTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:19:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiBODTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:19:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B965B201BB
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:19:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2XVGS014444;
        Tue, 15 Feb 2022 03:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=md9aztAC8puTXT9ocwE4Wac3gsc4e735TFx0GA8ypkA=;
 b=uyxq4aH+h0mB3Zg41ukr41m5TCNZfa08c1NtO9NukT54L7OgErg+dJ13lAImAkzJlUwz
 Oy9VE/Rx8+D3xxH1VBW74CZhsT88BsK6HNQBFnMPRaFJHazjZ7bDt3uyQZ1+CoU25hFO
 tPYlBtZdQ+tLEWPJq1GLIonvEupEnMn6kxdgowBdDKj0ms+oUStYvMmgufkP6/W0Mcmc
 MHwu3HI5VJPWX/2fESbhaJU07jJ86qribAFP+mmGyXws3cK+UXJsD9AE1jHUhaTlBrZQ
 8WI6mziuP9Wlqz6HNt/MW+bbFVZudmIt4WGmuAt2FK0jgqeswoJ3TL3mObu3BC8JUiAi lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64sbx6ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3Gmue057561;
        Tue, 15 Feb 2022 03:19:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:31 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMPE064243;
        Tue, 15 Feb 2022 03:19:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-7;
        Tue, 15 Feb 2022 03:19:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        emilne@redhat.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] qla2xxx: Add qla2x00_async_done routine for async routines.
Date:   Mon, 14 Feb 2022 22:19:19 -0500
Message-Id: <164489513312.15031.10750558363015103061.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208093946.4471-1-njavali@marvell.com>
References: <20220208093946.4471-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: V5OUI5FKqnFit1BsQoIyjmvEs2XTlXbC
X-Proofpoint-ORIG-GUID: V5OUI5FKqnFit1BsQoIyjmvEs2XTlXbC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Feb 2022 01:39:46 -0800, Nilesh Javali wrote:

> From: Saurav Kashyap <skashyap@marvell.com>
> 
> This done routine will delete the timer and check for it's return
> value and accordingly decrease the reference count.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/1] qla2xxx: Add qla2x00_async_done routine for async routines.
      https://git.kernel.org/mkp/scsi/c/49b729f58e7a

-- 
Martin K. Petersen	Oracle Linux Engineering
