Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63679C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 21:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 354F021882
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 21:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfHHVwz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 17:52:55 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:39744 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbfHHVwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 17:52:55 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2019 17:52:55 EDT
X-ASG-Debug-ID: 1565300264-0fb3b01884546ec0001-ziuLRu
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id qhlf26gEw12uEEGV (version=SSLv3 cipher=DES-CBC3-SHA bits=112 verify=NO); Thu, 08 Aug 2019 17:37:44 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
Received: from [10.157.2.224] (account tonyb HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 5.1.14)
  with ESMTPSA id 9044934; Thu, 08 Aug 2019 17:37:44 -0400
Subject: Re: [PATCH v3 00/20] sg: add v4 interface
To:     dgilbert@interlog.com, James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
X-ASG-Orig-Subj: Re: [PATCH v3 00/20] sg: add v4 interface
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        Arnd Bergmann <arnd@arndb.de>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <1565291455.3435.48.camel@linux.vnet.ibm.com>
 <7edab448-22cc-493a-f745-acc5be38f6a5@interlog.com>
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <5a80d09c-c1a5-429d-d46a-5e108b6292df@cybernetics.com>
Date:   Thu, 8 Aug 2019 17:37:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7edab448-22cc-493a-f745-acc5be38f6a5@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1565300264
X-Barracuda-Encrypted: DES-CBC3-SHA
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1325
X-Barracuda-BRTS-Status: 1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/19 5:08 PM, Douglas Gilbert wrote:
>
> Here is the full set of extra ioctls I have, or will be proposing:
>     SG_IOSUBMIT
>     SG_IOSUBMIT_V3
>     SG_IORECEIVE
>     SG_IORECEIVE_V3
>     SG_IOABORT
>     SG_SG_SET_GET_EXTENDED
>
> They are all new style ioctls using the _IOR(W) macros with fixed size
> objects referenced by the ioctl's third argument. ioctls have been
> referred to as the "garbage bin of Unix". Well that last one is a garbage
> bin within a garbage bin :-) On the plus side, it keeps that list
> relatively short.
>
> Doug Gilbert
>
>
> *** Tony Battersby is a sg driver power user. He has lamented wading through
>      very large logs looking for some hint of why the sg driver is playing
>      up. He has stated the strong preference for more, not less, ioctls.
>
One of the reasons ioctls have a bad reputation is because they can be
used to implement poorly-thought-out interfaces.  So kernel maintainers
push back on adding new ioctls.  But the push back isn't about the
number of ioctls, it is about the poor interfaces.  My advice was that
in general, to implement a given API, it would be better to add more
ioctls with a simple interface for each one rather than to add fewer
extremely complex multiplexing ioctls.

Tony Battersby
Cybernetics

