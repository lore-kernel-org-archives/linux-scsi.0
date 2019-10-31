Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C05CA9EC3
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 08:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8B12086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 08:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfJaIja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:39:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:42048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfJaIja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 04:39:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4BD67ACA4;
        Thu, 31 Oct 2019 08:39:28 +0000 (UTC)
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
 <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
 <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a640ee15-515b-6811-9883-48b49ead9276@suse.de>
Date:   Thu, 31 Oct 2019 09:39:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 6:01 PM, Bart Van Assche wrote:
> On 10/30/19 9:21 AM, Damien Le Moal wrote:
>> If you feel strongly about it, I have absolutely no problem with
>> dropping the patch. I just would like that it be dropped for the right
>> reasons...
> 
> Hi Damien,
> 
> What I'm wondering about is how the SCSI core should support residual
> overflow. Should a new member be introduced in struct scsi_request?
> Should resid_len be changed from unsigned int to int or should we
> perhaps follow yet another approach?
> 
Please introduce a new member to hold any overflow value.
And document where it is needed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
