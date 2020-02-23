Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB4FC35673
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 05:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9442214DB
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 05:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgBWF7p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 00:59:45 -0500
Received: from smtp.infotech.no ([82.134.31.41]:56490 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgBWF7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 00:59:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id CE3EF204190;
        Sun, 23 Feb 2020 06:59:42 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8rPMdZvXRf7L; Sun, 23 Feb 2020 06:59:41 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 138EC20417A;
        Sun, 23 Feb 2020 06:59:39 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 08/15] scsi_debug: add zone commands
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
 <20200220200838.15809-9-dgilbert@interlog.com>
 <DM5PR0401MB3591D78A720DD1CC1696241D9B120@DM5PR0401MB3591.namprd04.prod.outlook.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <59c21bb2-0eb8-5ed9-f460-f3a562ce3969@interlog.com>
Date:   Sun, 23 Feb 2020 00:59:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <DM5PR0401MB3591D78A720DD1CC1696241D9B120@DM5PR0401MB3591.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 4:44 a.m., Johannes Thumshirn wrote:
> On 20/02/2020 21:09, Douglas Gilbert wrote:
>> +enum sdebug_z_cond {	/* enumeration names taken from table 12, zbc2r04 */
>> +	zbc_not_write_pointer = 0x0, /* not in table 12; conventional zone */
>> +	zc1_empty = 0x1,
>> +	zc2_implicit_open,
>> +	zc3_explicit_open,
>> +	zc4_closed,
>> +	zc5_full = 0xe,	/* values per Zone Condition field in Report Zones */
>> +	zc6_read_only = 0xd,
>> +	zc7_offline = 0xf,
>> +};
> 
> Haven't checked the rest of scsi_debug, but I'd write these enum values
> in all caps. Furthermore I'd just call them EMPTY, OPEN, READ_ONLY,
> FULL, OFFLINE, etc..

Yes, they should be in upper case. The ZC1, ZC2, etc are the names of
states in these T10 documents: zbc-r05.pdf and zbc2r04a.pdf . As for
the final suggestion, the C compiler thinks otherwise, so the
enumeration constants need something that is relatively unique, hence
the chosen scheme.

ZC6 and ZC7 are being dropped as they only appear in ZBC-2 which is still
at the draft level while we are trying to implement the original (and
currently only) ZBC standard.

Doug Gilbert


