From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [CARE]: number of LUNS from REPORT LUNS data report and macros
Date: Mon, 26 Aug 2002 18:10:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826181058.A19719@eng2.beaverton.ibm.com>
References: <3D6ACCA2.68364DDA@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D6ACCA2.68364DDA@splentec.com>; from luben@splentec.com on Mon, Aug 26, 2002 at 08:49:38PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Luben -

On Mon, Aug 26, 2002 at 08:49:38PM -0400, Luben Tuikov wrote:
> Two issues here.

Thanks for the feedback.

> 
> Firstly, I don't think that one can quite do
> ``num_luns = (length / sizeof(ScsiLun));'' in scsi_scan.c.

length is the length returned from the REPORT LUNS, and sizeof(ScsiLun)
is the size of an element in the REPORT LUNS. I don't see any better
way to get the number of luns.

> The reason is that we should keep clear separation of what/how
> the kernel represents some standard/drafts data and how it comes
> from the device. I.e. one wouldn't assume (one step further) that
> _also_ the byte ordering is the same in the report data and in ScsiLun,
> i.e.  (ScsiLun *)(data+i*sizeof(ScsiLun)) ... not!

I don't quite follow the above, is there some line of code in scsi_scan.c
you can reference? Are you talking about the horrific scsilun_to_int?
Yes, it's ugly but as long as we have to make a four byte int from
an 8 byte not-even-close to an integer value, we need something like it
around.

> A SCSI LUN should be represented by ``u64''. Futhermore, only
> a LLDD should poplulate such a variable (as outlined in another email)
> directly or indirectly (though REPORT LUNS data).

IMO all the SCSI data is best represented as u8 chunks, but having a
ScsiLun type (even with the butchered case) makes this simple to change.
I see there are a bunch of u_char's, I'm not even sure if u8 or u_char
is right.

> Secondly, please get rid of the big
> #ifdef CONFIG_SCSI_REPORT_LUNS in scsi_scan.c.
> Linus has made this a point numerous times.

Yes, but it is a static function, so to get rid of the ifdefs here
I'd have to move code to a .h or something; I did do an inline
on the #else portion, so there is no #ifdef in the caller.

A patch (or two) might better explain specifics of what you want.

-- Patrick
