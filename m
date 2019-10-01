Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCD5C352A9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85A9620815
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TcbLcixz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJADyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:54:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50682 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfJADyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:54:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913sMDe162027;
        Tue, 1 Oct 2019 03:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=P0SIhqwVwF4KrzRiTFbotP1NB2jWE6iKzbCzwOdMV9w=;
 b=TcbLcixzA7OH5HESl/IOX243jp3sSpZuV0g1ttZW8ERoUfAVl7QJ7CuMeqWFstA/fP5l
 JgQDHPj9H3nOmbfDAHGeFQ/3Cd2NcIlNviX4XtuYrvfhiUSz7AxjmLSN2d0m1mhlbVUk
 4G8tz2Pk5VKAs/AEwHfLOI67ecrFBPz7pN+qDhQCM0rrGhPZ68zIhA/LAtNaF38lWqyu
 /3AxkZzkWhaxEkWdEsw38G5GK+kqdbnfIfnJ09X0475oELtIqp3F+yL0tyo2GVYRzv7f
 vFuzPkUZWEonA6fW2GOA/KR46i5NeyXUziB2f/GGnCIxbtpKbfl/hJtdAcxf3fgjffNc Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxuk1qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:54:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913mw3q005632;
        Tue, 1 Oct 2019 03:54:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vbqd03hjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:54:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x913sVuK026024;
        Tue, 1 Oct 2019 03:54:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:54:30 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190927073031.62296-1-dwagner@suse.de>
Date:   Mon, 30 Sep 2019 23:54:28 -0400
In-Reply-To: <20190927073031.62296-1-dwagner@suse.de> (Daniel Wagner's message
        of "Fri, 27 Sep 2019 09:30:31 +0200")
Message-ID: <yq18sq5w26j.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> Commit 88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not
> called from the completion path") introduced the WARN_ON_ONCE in
> qla2x00_status_cont_entry(). The assumption was that there is only one
> status continuations element. According to the firmware documentation
> it is possible that multiple status continuations are emitted by the
> firmware.

Applied to 5.4/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
