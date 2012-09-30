From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 15:03:48 -0400
Message-ID: <50689794.50203@pobox.com>
References: <Pine.LNX.4.44L0.1209291024380.29902-100000@netrider.rowland.org> <201209300031.04419.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201209300031.04419.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/29/2012 06:31 PM, Rafael J. Wysocki wrote:
> On Saturday, September 29, 2012, Alan Stern wrote:
>> Can arbitrary SCSI devices be ZP, or does this notion apply only to
>> ATAPI-based drives?  That's the key question, and the answer determines
>> where the ZP support belongs.
>
> I agree.  That said for now I'm not aware of any other ZP devices.  It also
> is unclear whether or not their requirements would be the same for the
> ZPODD devices.

Not quite.

The key question is whether or not this operates at the SCSI command set 
level.  ATAPI is simply SCSI MMC command set tunnelling.

The ATA-specific bits that belong in libata include everything below the 
SCSI command set: bus details, delivering the command to the device, 
returning the command response, etc.

sr handles the SCSI command set details.  SATA optical devices are 
aligned with the SCSI MMC command set, which periodically synchronizes 
with USB and ATAPI industry efforts.

There are ugly hacks around the edges, where sometimes ATA or USB 
subsystems may tweak the request or response in passing, but that is the 
general model:  it belongs in libata UNLESS the operation is occurring 
wholly at the SCSI command set level.

Because USB and ATA chose to use the SCSI command set, it is sadly 
inevitable that there might be a few details -- hopefully glossed over 
with layer-hopping hooks and flags -- within 'sr' that are bus-specific.

The simple fact of "only ZPODD devices out there are ATA" is not the 
decision-maker for where the code should live.  It is more a question 
where ZPODD belongs in the device/command set model currently employed.

	Jeff




