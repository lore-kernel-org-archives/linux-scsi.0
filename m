From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI luns
Date: Tue, 12 Jul 2005 12:17:53 -0400
Message-ID: <1121185078.4825.17.camel@mulgrave>
References: <1ba727770507120422562d525d@mail.gmail.com>
	 <1121168331.3171.21.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261834AbVGLRvr@vger.kernel.org>
In-Reply-To: <1121168331.3171.21.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Amrut Joshi <amrut.joshi@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks for redirecting to the correct list.

On Tue, 2005-07-12 at 13:38 +0200, Arjan van de Ven wrote:
> On Tue, 2005-07-12 at 16:52 +0530, Amrut Joshi wrote:
> > Currently linux scsi subsystem doesnt store the 8-byte luns which are
> > recieved in REPORT_LUNS reply. This information is forver lost once
> > the scan is over. In my LDD  I need this information. Currently I have
> > to snoop REPORT_LUNS reply, do scsilun_to_int for all the luns and

Our current transformation routine scsilun_to_int is bijective as long
as the original scsi_lun doesn't overrun 32 bits (which it might well do
one day).

Why can't you simply do this by transforming back the lun?

In general, I'm not in favour of adding redundant information to the
device structure, so if you can demonstrate we overrun our allotted 32
bits, the solution is probably to take lun up to u64 and still do the
back transform (the alternative being to substitute lun with it's
structural equivalen which would entail a lot of pain throught the SCSI
subsytem).

James
