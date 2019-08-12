Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0955C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 19:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4F320663
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 19:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHLThR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 15:37:17 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:53522 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfHLThR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 15:37:17 -0400
X-ASG-Debug-ID: 1565638634-0fb3b0188458a8b0001-ziuLRu
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id jc1DsmHGaNDZENOY (version=SSLv3 cipher=DES-CBC3-SHA bits=112 verify=NO); Mon, 12 Aug 2019 15:37:14 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
Received: from [10.157.2.224] (account tonyb HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 5.1.14)
  with ESMTPSA id 9050756; Mon, 12 Aug 2019 15:37:14 -0400
Subject: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     James Bottomley <jejb@linux.vnet.ibm.com>, dgilbert@interlog.com,
        linux-scsi@vger.kernel.org
X-ASG-Orig-Subj: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-18-dgilbert@interlog.com>
 <1565392510.17449.18.camel@linux.vnet.ibm.com>
 <048b4ab4-804b-f6ec-c35a-47cd2f8d8cda@interlog.com>
 <500183f3-fb16-77b7-90e0-5c8bb2a021c3@cybernetics.com>
 <1565635563.3287.1.camel@linux.vnet.ibm.com>
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <ccd96c6c-a4fb-e40b-8380-66bcdea96f93@cybernetics.com>
Date:   Mon, 12 Aug 2019 15:37:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565635563.3287.1.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1565638634
X-Barracuda-Encrypted: DES-CBC3-SHA
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1260
X-Barracuda-BRTS-Status: 1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/19 2:46 PM, James Bottomley wrote:
>
> So far we've mitigated the security threat by withdrawing the v4
> r/w interface which you don't use and keeping the sg nodes root only
> for v3 r/w.  Unless we get another security incident based on them, as
> long as the use case doesn't expand, I think the prior issue is pretty
> nasty but contained to root who should know what they're doing, so
> there's no pressing need to remove it.

So if there is no plan to remove read/write from sg v3 for root, then I
don't see a need for the new ioctl()s to replace them.


> Given that shifting to ioctls or a different async interface would be
> development anyway, is there a solid reason you couldn't also shift to
> v4 if you do that?  I know all the field names changed but for a
> standard SCSI command it should be very similar to v3.
>
>
I suppose we could move our codebase to sg v4 eventually.  Right now we
don't need any new features from it, so there is no compelling case to
make the move.  Besides, we are pretty far behind in the kernel version
that we are shipping due to lack of developer time, so it may be a long
time before I can update to a kernel version with these patches anyway.

Tony Battersby
Cybernetics

