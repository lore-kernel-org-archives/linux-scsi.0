From: Doug Ledford <dledford@redhat.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 15:55:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729155518.B20905@redhat.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D457FF3.C7A02C57@torque.net>; from dougg@torque.net on Mon, Jul 29, 2002 at 01:48:35PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 29, 2002 at 01:48:35PM -0400, Douglas Gilbert wrote:
> Hence in the development lk 2.5 series there are many stranded
> drivers, including ide-scsi, some of which have been converted "on
> the fly". His is an incomplete list of issues to be addressed
> in lower level (HBA) driver conversions:
>   - "eh" interface [mandatory]
>   - io_request_lock displaced by host_lock [mandatory]
>   - PCI memory/DMA interface
>   - driverfs aware
>   - autosense for high performance drivers (perhaps all)
> 
> As you point out autosense support (at the device level)
> is now mandatory in recent scsi drafts/standards. For
> simplicity of queueing logic, the sense buffer should not
> be left for the mid level to fetch (with a REQUEST SENSE).

It will be mandatory for the LLDD to do autosense.  All remnants of code 
to perform a follow up request sense operation *will* dissappear from the 
mid layer.  OTOH, the sense command and sense buffer will be pre-set for 
each device so at least the LLDD won't have to build their own command any 
longer, they can just change the command pointer from the original command 
to the sense command and the data buffer to the sense buffer and reissue 
the request.

> I have attempted the conversion on several HBA drivers
> (of which scsi_debug is the only one I maintain). As Ben
> LaHaise has pointed out, I have skipped addressing the
> "PCI memory/DMA interface" so far.

Feel lucky.  It's currently pissing me off and I'm thinking of changing 
it.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
