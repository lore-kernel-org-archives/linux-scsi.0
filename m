From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 13:15:27 -0600
Message-ID: <20071023191526.GS27248@parisc-linux.org>
References: <20071019183331.GC30807@parisc-linux.org> <471E260D.6030605@panasas.com> <20071023174804.GR27248@parisc-linux.org> <471E419C.9020005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36890 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJWTP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 15:15:28 -0400
Content-Disposition: inline
In-Reply-To: <471E419C.9020005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2007 at 08:46:52PM +0200, Boaz Harrosh wrote:
> > We could also add an alloc_bidi_cmnd/destroy_bidi_cmnd to the shost
> > template.  Presumably most commands won't be bidi for any given host,
> > so it'd be a waste of space to allocate them for all commands.
> 
> Well no one really knows. The OSD scsi devices I use are bidi only commands
> (OK not only, 99%). The rest are not yet defined. (Like raid arrays that do 
> write-return-XOR)

What's the usage scenario though?  Do we envisage one scsi_host being
dedicated to OSD, or do we envisage OSDs being one component on a FC
network?  I suspect the latter, which leads me to want to do something
like ...

struct qla_cmnd {
	char *sp;
	unsigned int compl_status;
	unsigned int resid_len;
	unsigned int scsi_status;
	unsigned int actual_snslen;
	unsigned int entry_status;
}

struct qla_bidi_cmnd {
	struct bidi_cmnd;
	struct qla_cmnd;
}

struct qla_cmnd {
	struct scsi_cmnd;
	struct qla_cmnd;
}

But then this requires us to have a bidi_queue_command.  That might not
be such a bad idea anyway ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
