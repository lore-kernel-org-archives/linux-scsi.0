From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 06 Jan 2003 11:43:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E19B24D.1080500@splentec.com>
References: <Pine.LNX.4.33L2.0301060956210.740-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries.Brouwer@cwi.nl, mdharm-kernel@one-eyed-alien.net, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Alan Stern wrote:
> 
>>The SCSI code has no means of knowing the actual length transferred,
>>so has no choice but to believe the length byte in the reply.
>>But the USB code does the transferring itself, and knows precisely
>>how many bytes were transferred. If 36 bytes were transferred and
>>the additional length byte is 0, indicating a length of 5, then the
>>USB code can fix the response and change the additional length byte
>>to 31, indicating a length of 36. That way the SCSI code knows that
>>not 5 but 36 bytes are valid, and it gets actual vendor and model strings.
> 
> 
> I'm not familiar with the details of the SCSI code you are referring to,
> but usb-storage does make available the actual transfer length.  All the
> transport routine paths set the resid field of the Scsi_Cmnd structure
> properly.  With this information, there should be no difficulty in
> determining how many bytes were transferred.  (Maybe the setting doesn't
> percolate up to the particular code you mention -- and maybe other host
> adapter drivers don't set resid correctly so you cannot rely on its value.
> I don't know what other problems might crop up.)

In this most recent case reported, this looks very similar to
overflow residual, but not quite the same. I.e. *more* data is
actually immediately available (in the buffer) than *we requested* or can
find out by other means (i.e. checking the ADDITIONAL LENGTH field).

But if we requested 36 and the transport provided 36 then the
residual should be 0 (set by the transport). Had we requested 5 and the
transport provided 36 then the residual should be 31, but there's no way
of reporting this residual, since it is an *overflow* residual, and from
the comments therein, cmd->resid is *only underflow* residual.

Thus, *if* the cmd->resid field is set properly, then something like this,
in SCSI Core, might suffice:

</Disclaimer: this is NOT actual C code, but should be descriptive enough/>

	int bytes_requested = <whatever>;
	int bytes_got, additional_len;
	...
	</ok, we got response from INQUIRY/>

	additional_len = buffer[4];
	bytes_got = max(bytes_requested - cmd->resid, 0);

	</now use bytes_got exclusively and ignore additional_len/>
	...
	</do assignments and whatever, and just before we're done print
	a nice warning message if bytes_got != additional_len+5 />

-- 
Luben


