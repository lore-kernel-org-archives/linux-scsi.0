From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Mon, 28 Apr 2003 17:33:43 -0400
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3EAD9E37.5050207@rogers.com>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave> <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave> <20030427023517.A15212@one-eyed-alien.net> <1051458107.2427.25.camel@fuzzy> <20030427125237.A23693@one-eyed-alien.net> <3EAD7B86.8060300@rogers.com> <20030428131938.A4255@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030428131938.A4255@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> 
>>So to repeat what the standards say and what SCSI Core
>>does: sr_bufflen, request_buflen, buflen *is* the
>>Expected (maxumum) Data Tranfer Length:
>>	- when it means Allocation Length it is the
>>maximum available space (e.g. IQUIRY, Request Sense),
>>(The transport CANNOT write more data than this!)
>>	- when it means Transfer Length it is the
>>Expected Data Transfer Length (READ/WRITE), and I say
>>``expected'' less any End Of Media or similar errors pop up,
>>(i.e. number of blocks from CDB * block_size = this value).
> 
> 
> So, to paraphrase and make certain I understand:  For a certain class of
> commands, buflen is the ALLOCATION LENGTH.  Right now, we guarantee that
> this matches the 'expected transfer length', but that's only by convention.

ALLOCATION LENGTH is for things like INQUIRY and REQUEST SENSE,
and its metric is bytes.

It is *this* value which the device server may send less data
or may _have_ more data than the length of the Data-In buffer.

I.e. it is this value for which we are not certain, this is to say,
the data-in buffer size (request_buflen) is a guess -- the device
may have more or less data to send.

(all directions are always with respect to the Initiator (SCSI Core)).

> For the other class of commands, it's a TRANSFER_LENGTH, which we guarantee
> to be the 'expected transfer length'.

In general -- yes.  When it is TRANSFER LENGTH (e.g. READ/WRITE), you
can be more or less certain that exactly that many blocks will
be transferred.  I.e. you can fully rely on request_buflen (bytes).
The exception is when an error occurs, like End Of Partition
or End of Media.
 
> You know, it occurs to me that we're talking in circles.  The only reason
> this is an issue is because usb-storage re-writes commands into something
> which is more acceptable -- if we eliminate this re-writing with a patch
> similar to Andries', the problem goes away.

As long as any re-writing is *not* arbitrary *and* is reversibe on
the way up.

As Alan Stern mentioned, it may be the case that the command sent is
sent as intended to test the device (or whatever).  If this will
crash the device, USB storage should return the appropriate sense data
or response code. If this will crash the system, SCSI Core
should return the appropriate response/error code.

All, please remember that we're providing mechanism, NOT policy.

So, ok, let us (SCSI Core) send the 10 byte versions of commands, unless
the device server reports CHECK CONDITION status with the sense key set to ILLEGAL REQUEST and an additional sense code of INVALID FIELD IN CDB.
(as per the standard), and then we drop to 6 (rarely).

Inquiry first 36, then more if needed.

As for REQUEST SENSE, the standards specify that in order to guarantee
that all sense data has been retrieved, ALLOCATION LENGTH should be 252.
And if less is specified, then the sense data is lost as REQUEST SENSE
clears the sense data buffer of the device server.

In this case you cannot blame SCSI Core or the application client,
and will have to filter it yourself or provide a settable filter
as per Alan Cox's suggestion for a filter (I think you had the same idea:
the filter framework is universal, but the values are per host/device settable).

(Because SCSI Core/Appl. Client have full right to request 252 bytes
in the ALLOCATION LENGTH field.)

In general, we cannot change SCSI Core much more than what SAM-3 and
SPC-3 specify in order to accomodate broken device servers of
a particular SCSI transport -- the transport is invisible to SCSI Core.

There can and will be a compromise, but only a LLDD knows the particulars
of the transport/ic and the device to do proper job in filtering or
whatever is necessary in order to deliver the command to the device --
but it will have to really be a minimalistic filter.

So overall I see a great improvement in SCSI Core regarding those
issues, beginning with Andries' patch (but buffer extents will have
to be checked!).

-- 
Luben



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
