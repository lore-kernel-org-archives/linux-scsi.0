From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [patches] rq_dev removal
Date: Fri, 01 Nov 2002 13:43:04 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC1EA38.2080105@torque.net>
References: <Pine.GSO.4.21.0210311715330.16688-100000@weyl.math.psu.edu> <20021031231801.GE13860@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: Alexander Viro <viro@math.psu.edu>, linux-scsi@vger.kernel.org

Willem Riede wrote:
> On 2002.10.31 17:43 Alexander Viro wrote:
> 
>>	Folks, ->rq_dev is going away in 2.5 RSN.  The only non-trivial
>>remaining uses were in SCSI (scsi_lib.c::scsi_get_request_dev() and
>>uses in st.c, osst.c and sg.c to identify a device).
>>
>>	Series of patches on ftp.math.psu.edu/pub/viro/P/P*-C45 deals
>>with that stuff and removes most of the uses of minor() in there.  Please,
>>review it.
> 
> 
> I reviewed the changes to osst (which I maintain).
> 
> [snip]
> 
>>	* sd.c and sr.c got a pointer to Scsi_Device_Template in
>>scsi_disk and scsi_cd resp.  That pointer is initialized to &s{d,r}_template.
>>disk->private_data points to that field (instead of entire scsi_disk/scsi_cd)
>>and old uses of disk->private_data are updated to compensate.
>>	* st.c, osst.c and sg.c got gendisks allocated, but not registered.
> 
> 
> How appropriate is it, to have something called '*disk' in a tape driver?
> I assume that at least the data in it is valid for this type of driver?

It seems as though sg's (scsi) _device_ abstraction has
been replaced by a _disk_ abstraction. At the very least
this is misleading for the dvd/cd writers, scanners,
tape robots and enclosures that sg typically deals with.

st, osst and sg are character device drivers (not block device
drivers).

<snip>

The patch on sg looks sound.

Doug Gilbert

