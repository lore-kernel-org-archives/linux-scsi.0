Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A5FC32751
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB6921873
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDNyaEku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbfHHBaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:30:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbfHHBaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:30:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781TW0G048712;
        Thu, 8 Aug 2019 01:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=WynY6nXwME0DR9PAu+tJ6emJNKimUsPqa4OPf2Sw6bs=;
 b=PDNyaEkuuU80CuIG13+H9wAbh2QdE4LY3bBg4jV77zQ7MzHfF3gazCgZWh6lj6U+zP0U
 7zJnJw1+kKa8p3QE0eocvkHiz+HcAk9t+PKvhCHnNRvLHRbQDJdtn1Vd6lRr71r+GdBK
 X6icZe2Re8oMuW/b2l9bFtl9h0J7MxiU/tnW9wrkc1mNr2Y1/8SnbWI3KQeu2L7++Pwx
 1J1oGIyJNzjOe1mpkk6D+KrUpBzAIfh29z6f3eL0RGV+aBZMZrTES5vJaq+apIZ5BjN5
 bubgfL+TE0Bg9RAkWgQNym9sytRA61K2NxdXyKc34GY3pWLQEGKEbcKlqxXDlJPiyCN4 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51pu7kb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:30:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781SNh9122368;
        Thu, 8 Aug 2019 01:30:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u763jhcap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:30:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x781U8cu032707;
        Thu, 8 Aug 2019 01:30:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:30:08 -0700
To:     Qian Cai <cai@lca.pw>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/megaraid_sas: fix a compilation warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1564151143-22889-1-git-send-email-cai@lca.pw>
Date:   Wed, 07 Aug 2019 21:30:06 -0400
In-Reply-To: <1564151143-22889-1-git-send-email-cai@lca.pw> (Qian Cai's
        message of "Fri, 26 Jul 2019 10:25:43 -0400")
Message-ID: <yq1r25we95t.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=27 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=796
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=27 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=866 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808013006.jbkIkjoIuR-27Jlgc6wC14s-zbVXZHAO8eJxpsPy-04@z>


Qian,

> The commit de516379e85f ("scsi: megaraid_sas: changes to function
> prototypes") introduced a comilation warning due to it changed the
> function prototype of read_fw_status_reg() to take an instance pointer
> instead, but forgot to remove an unused variable.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
