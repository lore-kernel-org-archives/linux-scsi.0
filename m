From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing
 file  transfers
Date: Fri, 27 Sep 2002 14:58:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2628736224.1033160295@aslan.btc.adaptec.com>
References: <200209271721.g8RHLTn05231@localhost.localdomain>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209271721.g8RHLTn05231@localhost.localdomain>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>> Hooks for sending ordered tags have been in the aic7xxx driver, at
>> least in FreeBSD's version, since '97.  As soon as the Linux cmd
>> blocks have such information it will be trivial to have the aic7xxx
>> driver issue the appropriate tag types.
> 
> They already do in 2.5, see scsi_populate_tag_msg() in scsi.h.  This
> assumes  you're using the generic tag queueing, which the aic7xxx
> doesn't, but you  could easily key the tag type off REQ_BARRIER.

If anyone wants to play with the updated aic7xxx and aic79xx drivers
(new port to 2.5, plus it honors the otag stuff), you can pick it up
from here:



--On Friday, September 27, 2002 13:21:29 -0400 James Bottomley
<James.Bottomley@steeleye.com> wrote:

>> Which part of the OS are you talking about?
> 
> I'm not, I'm talking about the pure physical characteristics of the
> transport  bus.
> 
>> I also do not believe that the command overhead is as significant as
>> you suggest.  I've personally seen a non-packetized SCSI bus perform
>> over 15K transactions per-second.
> 
> Well, lets assume the simplest setup possible: select + tag msg + 10 byte 
> command + disconnect + reselect + status; that's 17 bytes async.  The
> maximum  bus speed async narrow is about 4Mb/s, so those 17 bytes take
> around 4us to  transmit.  On a wide Ultra2 bus, the data rate is about
> 80Mb/s so it takes  50us to transmit 4k or 800us to transmit 64k.
> However, the major killer in  this model is going to be disconnection
> delay at around 200us (dwarfing  arbitration delay, bus settle time etc).
> For 4k packets you spend about 3  times longer arbitrating for the bus
> than you do transmitting data.  For 64k  packets it's 25% of your data
> transmit time in arbitration.  Your theoretical  throughput for 4k
> packets is thus 20Mb/s.  In my book that's a significant  loss on an
> 80Mb/s bus.
> 
> On Fabric busses, you move to the network model and collision
> probabilities  which increase as the packet size goes down.
> 
> gibbs@scsiguy.com said:
>> Because of read-ahead, the OS should never send 16 4k contiguous reads
>> to the I/O layer for the same application.
> 
> read ahead is basically a very simplistic form of I/O scheduling.  
> 


--On Friday, September 27, 2002 13:21:29 -0400 James Bottomley
<James.Bottomley@steeleye.com> wrote:

>> Which part of the OS are you talking about?
> 
> I'm not, I'm talking about the pure physical characteristics of the
> transport  bus.
> 
>> I also do not believe that the command overhead is as significant as
>> you suggest.  I've personally seen a non-packetized SCSI bus perform
>> over 15K transactions per-second.
> 
> Well, lets assume the simplest setup possible: select + tag msg + 10 byte 
> command + disconnect + reselect + status; that's 17 bytes async.  The
> maximum  bus speed async narrow is about 4Mb/s, so those 17 bytes take
> around 4us to  transmit.  On a wide Ultra2 bus, the data rate is about
> 80Mb/s so it takes  50us to transmit 4k or 800us to transmit 64k.
> However, the major killer in  this model is going to be disconnection
> delay at around 200us (dwarfing  arbitration delay, bus settle time etc).
> For 4k packets you spend about 3  times longer arbitrating for the bus
> than you do transmitting data.  For 64k  packets it's 25% of your data
> transmit time in arbitration.  Your theoretical  throughput for 4k
> packets is thus 20Mb/s.  In my book that's a significant  loss on an
> 80Mb/s bus.
> 
> On Fabric busses, you move to the network model and collision
> probabilities  which increase as the packet size goes down.
> 
> gibbs@scsiguy.com said:
>> Because of read-ahead, the OS should never send 16 4k contiguous reads
>> to the I/O layer for the same application.
> 
> read ahead is basically a very simplistic form of I/O scheduling.  
> 

http://people.FreeBSD.org/~gibbs/linux/linux-2.5-aic79xxx.tar.gz

--
Justin
