From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/20] target: Eliminate usage of struct se_mem
Date: Mon, 18 Jul 2011 11:44:18 -0700
Message-ID: <1311014658.16756.13.camel@haakon2.linux-iscsi.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
	 <1310174329-22228-7-git-send-email-agrover@redhat.com>
	 <1310932648.26130.32.camel@haakon2.linux-iscsi.org>
	 <4E246A75.5000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39689 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1GRSxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 14:53:30 -0400
In-Reply-To: <4E246A75.5000101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2011-07-18 at 10:16 -0700, Andy Grover wrote:
> On 07/17/2011 12:57 PM, Nicholas A. Bellinger wrote:
> > Although this patch did not directly remove the memsets for newly
> > allocated pages used with transport_generic_map_mem_to_cmd(), the issue
> > as below of reproducable strangeness with control CDB payloads without
> > the explict memset of allocated pages.  As much as I would have liked to
> > leave the memset out, I don't think it's safe to do.  Added the
> > following:
> > 
> > commit 7c7649750eb47035ac4fb0123f2e49c1c47c8a15
> > Author: Nicholas Bellinger <nab@linux-iscsi.org>
> > Date:   Sun Jul 17 00:20:07 2011 -0700
> > 
> >     target/iscsi: Make iscsit_alloc_buffs explict memset allocated pages
> 
> Hi nab, obviously if it's breaking things the memsets need to go back
> for now, but surely it's a sign that somewhere there's a bug. You only
> see corruption with control CDBs you say? Any more info on the
> strangeness you're seeing?
> 

The immediate case that I ran into with the very latest iscsi-target
code was bogus output with 'sg_inq -i' (INQUIRY EVPD=0x83) in the
'Designation descriptor number 5' field.









