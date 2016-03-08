From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Mon, 7 Mar 2016 17:02:32 -0800
Message-ID: <56DE24A8.2060305@suse.com>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com>
 <1455299691.2396.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbcCHBGO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2016 20:06:14 -0500
In-Reply-To: <1455299691.2396.45.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com

On 02/12/2016 09:54 AM, James Bottomley wrote:
> On Fri, 2016-02-12 at 09:38 -0800, Lee Duncan wrote:
>> The scsi_transport_iscsi module already uses the ida_simple
>> routines for managing the target ID, if requested to do
>> so. This change replaces an ever-increasing atomic integer
>> that tracks the session ID itself with the ida_simple
>> family of routines. This means that the session ID
>> will be reclaimed and can be reused when the session
>> is freed.
> 
> Is reusing session ID's really a good idea?  For sequential sessions it
> means that the ID of the next session will be re-used, i.e. the same as
> the previous sessions, which could lead to target confusion.  I think
> local uniqueness of session IDs is more important than wrap around
> because sessions are short lived entities and the chances of the same
> session being alive by the time we've wrapped is pretty tiny.
> 
> If you can demostrate a multi-target problem, perhaps we should rather
> fix this by making the next session id a target local quantity?
> 
> James
> 

It looks like Mike and Chris are good with it. And I'd really like to
get rid of yet another atomic int.

Are you satisfied with this one?
-- 
Lee
