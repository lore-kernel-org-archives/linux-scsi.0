From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 18 Feb 2003 18:35:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E52C327.3020503@splentec.com>
References: <Pine.LNX.4.10.10302181352150.3880-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Andre Hedrick wrote:
> Luben:
> 
> <Point 4 answered>
> **********************
> Date: Tue, 26 Mar 2002 15:31:41 -0500
> From: Luben Tuikov <luben@splentec.com>
> To: iSCSI <ips@ece.cmu.edu>, <other names deleted>
> Subject: iSCSI: Login stage transition; T bit
> **********************

Yes, I remember writing this message about a year ago.

Why you're refering to IPS and why you're refering to
this message and what it has to do with anything here
is beyond me.

[[ This email has to do with redundant information in
the PDU on iSCSI connection login -- *completely irrelevant*
here.  Normalization clearly shows the redundancy, people
agreed that it exists, but the consensus was that since
login were very cryptic in earlier versions, we left it
like this. ]]

Point 4 was of personal nature directed TO YOU,
to stop speculating over uncertainities, and write cr*p.

> <Point 3 answered>
> 
> I know exactly what a portal, since I have already abstractived it away in
> the current environment, I see no need to add such additional layering.
> The current mid-layer handles it fine if you know how to map the issue
> according to its rules.
> 
> I know exactly what an iSCSI TPGT is and the relation to the DOMAIN.
>
> <Point 2 answered>
> 
> Making a target a collecion of LUs becomes a problem once you hit the
> saturate the queue of the associated HBA's.  Since Linux associates the
> queue depth to the HBA and not the actual device, other problems arrise.

But we're discussing a NEW SCSI Core! Why cannot you understand this?

SPI Portals will have a per portal cmd queue length limit, but
other transports will NOT have those limits.  Because of SAN's, LUN masking,
etc, other transports will have a per target and per LU queue length limit,
as each logical unit has a Task Set (SAM3r04, 4.8, figure 14),
and the former is set by the transport (and may be dynamic).

This is why, Doug, rightfully so, wants to have specifics in
the struct scsi_portal, whether it is SPI, SAS, FC, etc.

This is the whole point of ``collectively working'' people.

> HBA queue detpth == 255/256
> HDA queue detpth == 31/32
> 
> HBA has 16 HDA's (for this example).
> 
> Artificially pooling to make two virtual HBA's of 8 HDA's each, while not
> constraining the queue depth, will explode the midlayer.
> 
> Now assume an expanded model with N physical HBA's and load balancing the
> queue issue becomes impossible.  So one needs to address it as another
> issue.

I repeat, what we're discussing is 2.7 (3.1) stuff, some years ahead.
We're not planning to do anything with SCSI Core now.

Everyone understands here that, the current scsi_host and the new
scsi_portal _represents_ the same thing in case it is SPI.  So, in
it's simplest form, you can ``Query replace regexp:''
``host'' with ``portal'' and from SAM-2/3 point of view this
will be *correct*.

The difference is that ``portal'' will abstact the type of controller,
whether it is SPI, FC, etc, and thus will offer more flexibility
for LLDDs, and closer representation of what is out there and
what will come.

By the time of 2.7, more exotic SCSI devices will appear working over
more exotic/newer SCSI transports, thus then we'll feel even more
the need for some changes.

> <Point 1 answered>
> 
> OIC, maybe you should be more clear in your choice of terms.  Given the
> answer to point 4 above is subject to your motivation.

I've explained my choice of terms very carefully, giving plenty of
examples, and plenty of cross-references in SAM-2/3 and SPC-2/3.

-- 
Luben


