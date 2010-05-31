From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] [tgt]: Add proper CDB passthrough for SG_IO
	backstores
Date: Sun, 30 May 2010 21:06:40 -0700
Message-ID: <1275278800.32585.92.camel@haakon2.linux-iscsi.org>
References: <1274159582-6074-1-git-send-email-nab@linux-iscsi.org>
	 <4C023192.9080503@panasas.com>
	 <20100531123241H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:27223 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750747Ab0EaEJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2010 00:09:15 -0400
In-Reply-To: <20100531123241H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, stgt@vger.kernel.org, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, James.Bottomley@suse.de, dgilbert@interlog.com

On Mon, 2010-05-31 at 12:32 +0900, FUJITA Tomonori wrote:
> On Sun, 30 May 2010 12:36:18 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > > @@ -125,7 +141,7 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
> > >  		set_cmd_async(cmd);
> > >  	else {
> > >  		eprintf("failed to start cmd 0x%p\n", cmd);
> > > -		set_cmd_failed(cmd);
> > > +		return set_cmd_failed(cmd);
> > >  	}
> > >  	return 0;
> > >  }
> > > @@ -238,6 +254,7 @@ static int bs_sg_cmd_done(struct scsi_cmd *cmd)
> > >  static struct backingstore_template sg_bst = {
> > >  	.bs_name		= "sg",
> > >  	.bs_datasize		= 0,
> > > +	.bs_passthrough		= 1,
> > >  	.bs_open		= bs_sg_open,
> > >  	.bs_close		= bs_sg_close,
> > >  	.bs_cmd_submit		= bs_sg_cmd_submit,
> > 
> > And again the Second patch should just fold into this one. And the final disposition will
> > just set the .bs_cmd_submit to the proper one.
> 
> Hmm, that means this patchset adds new I/O code with sg (or
> bsg). That's not passthrough..
> 
> I think that passthrough needs to overwrite some of struct
> device_type_template and modify target_cmd_queue().

Indeed.  Expecting the passthrough to bypass the STGT port and CDB
emulation at the top of scsi_cmd_perform() would probably make sense
AFAICT.

So that said, at which spot in target_cmd_queue() would it make sense
for incoming struct scsi_cmd to be handled off for passthrough..?

Best,

--nab


