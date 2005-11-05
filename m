From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] [Merging ATA passthru] on  integratingSMART/ATA-Security in usb-storage driver
Date: Sat, 5 Nov 2005 10:01:37 -0800
Message-ID: <4A41CE59-1FF0-4FC0-B2D5-7FDD3FC6ED28@ieee.org>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <20051104154613.189d5f43.zaitcev@redhat.com> <436CDBC1.3010208@gmx.de>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <436CDBC1.3010208@gmx.de>
Sender: linux-ide-owner@vger.kernel.org
To: USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>> The problem then is with vendor specific commands as SCSI core
>>> mangles those as well.  The vendor specific command I had issues
>>> with is the "ATACB" ATA passthru cdb that cypress boards understand.
>>> CDB[1] is a signature byte that must be 0x24.  Needless to say,
>>> that leading 2 gets masked off to a 0, and the drive aborts the
>>> ATACB.  Now cypress could have been smarter about designing their
>>> cdb, but they wern't, and so there really needs to be a way to tell
>>> SCSI core "hands off the cdb".

I may be remembering this "could have been smarter" choice was  
conscious.

This design work was done in Boise by ISD, later acquired by the  
Cypress San Diego people?  I didn't work for them, but I knew some of  
the time.  At the time people didn't want opaque pass thru to work,  
only fully transparent pass thru.  People looked around for some bits  
that most fragile-because-opaque pass thru schemes stomp on, and  
found mask xE0 in CDB byte 1.

The push against making ATA pass thru too easy came from the debates  
over whether to encode storage requests as ATA or SCSI or USB or a  
mix or all three.  At the time we were advocating SCSI & deprecating  
ATA, because ATA thru USB had reached the market first without  
allowing for RMB ATAPI thru USB.  The revolutionary purely USB  
encoding that a solution like ub.ko allows had no traction at all.

Another analogous theoretical possibility we deprecated at the same  
time was devices that simultaneously accepted both CBI & BBB  
encodings of SCSI.  Again the issue was the hosts that might have  
neglected to rapidly adopt SCSI thru BBB, and thus implicitly RMB  
support, if ATA thru CB had also been a mass-produced option.

I can't remember if the '\x24' = '$' = U.S. dollar sign pun was  
significant.

Certainly SCSI thru BBB worked well enough that the efforts to step  
further forward lost impetus.  The fact that ATA, while lacking RMB  
support, includes encodings for purportedly useful requests that SCSI  
lacks, such as SMART, gathered no significant attention.
