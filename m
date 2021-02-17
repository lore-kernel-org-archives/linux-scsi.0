Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8DDC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 11:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4495364E42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 11:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhBQLRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 06:17:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44752 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhBQLRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 06:17:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HBEW0x141359;
        Wed, 17 Feb 2021 11:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LvbPbbE4n9uJRD5g72FtjniY2St1BQ3aC96cFx/OMHU=;
 b=jHCCi4tPR/e8ceNiAAc51kIYwKuiATlhoo4VPfeuWJFINwOvTJMQGV4MSKkyfAxxsVWo
 aFw6ZK9UsYW/Ue7ofB0mQBUINZOaygidsXHfr20tvLe8PPra3DLhoNCJbpcH/6oLJuzW
 4pEA9JikMLcwZ5tLUNPvQbPC0T4JCV1/oBWxlDqNFGPT6C4StmbvRucp/fvp38osLZaS
 ilb1AMQ1WDr/uEXUVdDzImUXRE1fP3WZLnFWE7pwSNMbmAR32mnjqRPgO7I/AcdJfkRX
 D0ubifjFiJgg4zFbCgxqBCGj5dMEW6YRJ6AmdWb95nN27K7QVI9m4gAoiIroa+F/aC1C 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49ba5cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 11:16:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HBGMnh081480;
        Wed, 17 Feb 2021 11:16:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 36prbpc34j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 11:16:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11HBGiKF006316;
        Wed, 17 Feb 2021 11:16:45 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Feb 2021 03:16:44 -0800
Date:   Wed, 17 Feb 2021 14:16:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <20210217111634.GL2222@kadam>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <BL0PR04MB651453A8B57118B3C1818ECDE7869@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB359823B2D42A6E31D5F6E5369B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB359823B2D42A6E31D5F6E5369B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 17, 2021 at 09:18:37AM +0000, Johannes Thumshirn wrote:
>  * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
> 
> So yeah, we should've read that before calling kvcalloc(..., GFP_NOIO).

This is a Smatch check now and checks are better than comments.  :)

regards,
dan carpenter
