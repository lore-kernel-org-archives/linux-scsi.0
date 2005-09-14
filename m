From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
	(end devices)
Date: Wed, 14 Sep 2005 14:47:59 -0400
Message-ID: <1126723680.4588.9.camel@mulgrave>
References: <20050910024454.20602.qmail@web51613.mail.yahoo.com>
	 <1126368081.4813.46.camel@mulgrave> <4325997D.3050103@adaptec.com>
	 <20050912162739.GA11455@us.ibm.com> <4326964B.9010503@torque.net>
	 <20050913224215.GB1308@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932737AbVINTmc@vger.kernel.org>
In-Reply-To: <20050913224215.GB1308@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, Luben Tuikov <luben_tuikov@adaptec.com>, ltuikov@yahoo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-09-13 at 15:42 -0700, Patrick Mansfield wrote:
> So adding a W_LUN at this point does not add any value ... maybe it looks
> nice in the spec and in someones firmware, but it does not add anything
> that I can see.

Well I agree with the analysis, but even given that, we have a linux
implementation problem: We have to get an inquiry response first before
we begin a report luns scan.  An array implementing a W_LUN is entitled
not respond on LUN 0 to INQUIRY with an error, which would mean we don't
see it.

Therefore, I think our strategy has to be when the current probe fails
because of no LUN 0 try a report luns scan on the W_LUN anyway as long
as the transport indicates it is capable of supporting it (i.e. as long
as it has max_luns set at 0xffff or higher).

James
