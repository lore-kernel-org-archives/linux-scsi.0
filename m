From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 11:25:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <02Apr16.112509edt.119051@cyborg.cybernetics.com>
References: <200204161456.g3GEuo302374@localhost.localdomain>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200204161456.g3GEuo302374@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, "'Justin T. Gibbs'" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

> > If you insist on doing this, lets at least preserve the current
> > behavior:
>
> > 	/*
> > 	 * FIXME: this driver treats deferred errors are fatal for
> [...]
> > 	if (scsi_sense_valid(SCpnt)
> > 	 && scsi_sense_key(SCpnt) == SKEY_CURRENT_ERROR) {
>
> Excellent!  It's a lot more readable for people not versed in
> sense buffer
> layout, thanks!

Why are you calling it the sense key?  Current vs. deferred error is
indicated by the error code (sense_data[0] & 0x7f), not the sense key
(sense_data[2] & 0x0f).  Calling it the sense key may lead to confusion for
those who are versed in sense buffer layout.

Tony

