Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942A9C46466
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B7321707
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dirpsFas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCBLf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:11:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJCBLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:11:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931AkZD170346;
        Sat, 3 Oct 2020 01:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=yoC4tlx0bgWcBOCMfOT1xNTc5SatBxasTSFvK+vjszY=;
 b=dirpsFasiCq1ib7bii7b9ccjSZJcI9XJqrLb6OcdfXz5/dVyO7nM8HtQHrv7TMgWCLE4
 PoHJ1rU+HColq+vYBFWNyXBEdFI7LX7q4l2UtBBdeeYQPppR+odW+9Uz6rbf9mXtr+Au
 xuhL/mC9nKlw4GaDiIJHh5yEtPOwWv0ZdSCKeIj+NeNX0aQ4izNu4mWbC9std7/9MoCR
 JNrpzQL3m2D+oTSMW9hwsuc7L6mgrFuq/8n6n6WjFfssLymr8wcBREFNwy9odKB685H3
 gVlg18GRchW4Jzp8B1dAJDoYY0ctauFUx9wwMhq8J2wHPZVNAzrH8/bxVC+mWkDWTy1i Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9nne7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:11:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931B1mO162841;
        Sat, 3 Oct 2020 01:11:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33xfb8g20p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:11:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0931BGoA027064;
        Sat, 3 Oct 2020 01:11:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:11:14 -0700
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Cc:     "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        Martin Wilck <mwilck@suse.com>,
        Laurence Oberman <loberman@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
Subject: Re: [PATCH] fnic: to not call 'scsi_done()' for unhandled commands
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eemgdsi2.fsf@ca-mkp.ca.oracle.com>
References: <20200515112647.49260-1-hare@suse.de>
        <fe3e6ab8cfeb23dc46f0413ddfd47efe5e33df7f.camel@redhat.com>
        <5aa5ed17-e763-4b07-7526-fe1c97c04f31@suse.de>
        <62ac9a52021d3217171a9d1a3ce5eef913780273.camel@redhat.com>
        <9c0b41a03f636d1ef98da9f8a12422d61d71fbff.camel@suse.com>
        <BYAPR11MB29971B225AB19F0DE072AF0BD7770@BYAPR11MB2997.namprd11.prod.outlook.com>
        <BY5PR11MB3863DF6CE5C19EC0CFEA59F0C3380@BY5PR11MB3863.namprd11.prod.outlook.com>
        <BY5PR11MB38636B3EF3A314D741AE0BDFC3320@BY5PR11MB3863.namprd11.prod.outlook.com>
Date:   Fri, 02 Oct 2020 21:11:12 -0400
In-Reply-To: <BY5PR11MB38636B3EF3A314D741AE0BDFC3320@BY5PR11MB3863.namprd11.prod.outlook.com>
        (Karan Tilak Kumar's message of "Tue, 29 Sep 2020 22:45:06 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030010
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> This fix was tested by Cisco QA and the fix looks good.

Applied to 5.10/scsi-staging with a warning fix. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
