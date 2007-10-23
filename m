From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 21:49:12 +0200
Message-ID: <471E5038.8010600@panasas.com>
References: <20071019183331.GC30807@parisc-linux.org> <471E260D.6030605@panasas.com> <20071023174804.GR27248@parisc-linux.org> <471E419C.9020005@panasas.com> <20071023191526.GS27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31867 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684AbXJWTtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 15:49:18 -0400
In-Reply-To: <20071023191526.GS27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 23 2007 at 21:15 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Oct 23, 2007 at 08:46:52PM +0200, Boaz Harrosh wrote:
>>> We could also add an alloc_bidi_cmnd/destroy_bidi_cmnd to the shost
>>> template.  Presumably most commands won't be bidi for any given host,
>>> so it'd be a waste of space to allocate them for all commands.
>> Well no one really knows. The OSD scsi devices I use are bidi only commands
>> (OK not only, 99%). The rest are not yet defined. (Like raid arrays that do 
>> write-return-XOR)
> 
> What's the usage scenario though?  Do we envisage one scsi_host being
> dedicated to OSD, or do we envisage OSDs being one component on a FC
> network?  I suspect the latter, which leads me to want to do something
> like ...
> 
Yes, like I have OSD devices on the other side of an iscsi transport.
So there can be other none OSD devices on the iscsi initiator. It's
a per device thing.

> struct qla_cmnd {
> 	char *sp;
> 	unsigned int compl_status;
> 	unsigned int resid_len;
> 	unsigned int scsi_status;
> 	unsigned int actual_snslen;
> 	unsigned int entry_status;
> }
> 
> struct qla_bidi_cmnd {
> 	struct bidi_cmnd;
> 	struct qla_cmnd;
> }
> 
> struct qla_cmnd {
> 	struct scsi_cmnd;
> 	struct qla_cmnd;
> }
> 
> But then this requires us to have a bidi_queue_command.  That might not
> be such a bad idea anyway ...
> 
The current solution is pretty simple, we hang an extra scsi_data_buffer on
cmd->request->next_rq->special and allocate it when needed from a new cache_mem_pool
of bidi scsi_data_buffer's. Since for an OSD device all Cmnds are bidi, I thought
of saving that extra allocation. But it looks like the current model is not working
for my case, so I'll keep it as it is now.

You can see an example of this here:
http://www.bhalevy.com/open-osd/download/bidi_2.6.23/0004-SCSI-bidi-support.patch

Thanks
Boaz
 
