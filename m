From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Question: where should the SCSI driver place MODE_SENSE data ?
Date: Wed, 22 Mar 2006 10:14:37 -0600
Message-ID: <1143044077.3633.15.camel@mulgrave.il.steeleye.com>
References: <9738BCBE884FDB42801FAD8A7769C26514211A@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751339AbWCVQOm@vger.kernel.org>
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26514211A@NAMAIL1.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2006-03-22 at 08:52 -0700, Ju, Seokmann wrote:
> On Tuesday, March 21, 2006 6:02 PM, James Bottomley wrote:
> > I don't understand the question.  Are you asking why
> > sd_read_write_protect_flag and sd_read_cache_type operate in the way
> > they do?  i.e. header first then actual data.
> For any SCSI command including MODE_SENSE, 'bufflen'in scsi_cmnd structure holds actual data buffer size in bytes if 'use_sg' flage is NOT set.
> The question is that "value of bufflen is 4 for the sd_read_cache_type operation and that is NOT sufficient to return header and page data by driver".
> If there is something that I misunderstood with the operation, please guide.

If you look at the functions in sd.c you'll see it goes about asking for
mode sense very carefully, because there are a lot of broken devices out
there.  The first request is only for enough of the headers to work out
the length of the page.

James
