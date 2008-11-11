From: jim owens <jowens@hp.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 09:55:59 -0500
Message-ID: <49199CFF.8080002@hp.com>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49198FC3.7080301@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
> Thing is being pitched to answer a very specific customer use case - 
> shared storage (mid to high end almost exclusively) with several 
> different users and applications....

And by "different users" these customers almost always mean
different operating systems.  They are combining storage into
a central location for easier management.

So "exact unmapped tracking by the filesystem" is impossible
and not part of the requirement.  Doesn't mean we can't make our
filesystems better, but forget about a perfect ability to known
just how much space we really have once we do an unmap.

We can't tell how much of our unmapped space the device has
given away to someone else and we cannot prevent the device
from failing a write to an unmapped block if all the space
is gone.  It is just an IO error, and possible fs-is-offline
if that block we failed was metadata!

It is up to the customer to manage their storage so it never
reaches the unable-to-write state.

jim
