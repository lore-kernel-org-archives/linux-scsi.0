From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 17:07:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106220743.GA29126@redhat.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <3E19EBC4.6000601@splentec.com> <20030106130547.E13916@one-eyed-alien.net> <3E19F223.4020208@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E19F223.4020208@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, Jan 06, 2003 at 04:16:19PM -0500, Luben Tuikov wrote:
> Matthew Dharm wrote:
> >I'm told this is a bad idea because there are some HBA which snoop the
> >INQUIRY data.  Since I don't know how that snooping works, I can't comment
> >further.
> 
> I do, in my own LLDDs. If anything the additional length might increase.
> Others snoop it for their own awareness of the device and personal gains
> to possibly result in better service to the actual device.
> 
> I cannot see how this could fail.

This can't fail.  Luben's right here.  If the lldd is snooping INQUIRY 
response, then the lldd is responsible for knowing how much it actually 
transferred and the scsi mid layer is not on the hook for telling it 
anything.  We are free to play our "try different INQUIRY lengths" games 
at the mid level and ignore any lldd snooping entirely.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
