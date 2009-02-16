From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: pNFS rant (was Re: [PATCH 1/8] exofs: Kbuild, Headers and osd
 utils)
Date: Mon, 16 Feb 2009 14:45:42 +0200
Message-ID: <49995FF6.1050502@panasas.com>
References: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>	<20090216131806X.fujita.tomonori@lab.ntt.co.jp>	<499928A3.60507@panasas.com> <20090216180028C.fujita.tomonori@lab.ntt.co.jp> <49992F99.1060404@panasas.com> <49993182.3010707@garzik.org> <49993DAD.40407@panasas.com> <49994860.9060109@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49994860.9060109@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, avishay@gmail.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> No can do. exofs is meant to be a reference implementation of a pNFS-objects
>> file serving system. Have you read the spec of pNFS-objects layout? they define
>> RAID 0, 1, 5, and 6. In pNFS the MDS is suppose to be able to write the data
>> for its clients as NFS, so it needs to have all the infra structure and knowledge
>> of an Client pNFS-object layout drive.
> 
> Yes, I have studied pNFS!  I plan to add v4.1 and pNFS support to my NFS 
> server, once v4.0 support is working well.
> 
> 
> pNFS The Theory:   is wise and necessary:  permit clients to directly 
> connect to data storage, rather than copying through the metadata 
> server(s).  This is what every distributed filesystem is doing these 
> days -- direct to data server for bulk data read/write.
> 
> pNFS The Specification:   is an utter piece of shit.  I can only presume 
> some shady backroom deal in a smoke-filled room was the reason this saw 
> the light of day.
> 
> 
> In a sane world, NFS clients would speak... NFS.
> 
> In the crazy world of pNFS, NFS clients are now forced to speak NFS, 
> SCSI, RAID, and any number of proprietary layout types.  When will HTTP 
> be added to the list?  :)
> 
> But anything beyond the NFS protocol for talking client <-> data servers 
> is code bloat complexity madness for an NFS client that wishes to be 
> compatible with "most of the NFS 4.1 world".
> 
> An ideal NFS client for pNFS should be asked to do these two things, and 
> nothing more:
> 
> 1) send metadata transactions to one or more metadata servers, using 
> well-known NFS protocol
> 
> 2) send data to one or more data servers, using well-known NFS protocol 
> subset designed for storage (v4.1, section 13.6)
> 
> But no.
> 
> pNFS has forced a huge complexity on the NFS client, by permitting an 
> unbounded number of network protocols.  A "layout plugin" layer is 
> required.  SCSI and OSD support are REQUIRED for any reasonably 
> compatible setup going forward.
> 
> But even more than the technical complexity, this is the first time in 
> NFS history that NFS has required a protocol besides... NFS.
> 
> pNFS means that a useful. compatible NFS client must know all these 
> storage protocols, in addition to NFS.
> 
> Furthermore, enabling proprietary layout types means that it is easy for 
> a "compatible" v4.1 client to be denied parallel access to data 
> available to other "compatible" v4.1 clients:
> 
> 	Client A: Linux, fully open source
> 
> 	Client B: Linux, with closed source module for
> 		  layout type SuperWhizBang storage
> 
> 	Both Client A and Client B can claim to be NFS v4.1 and pNFS
> 	compatible,
> 	yet Client A must read data through the metadata
> 	server because it lacks the SuperWhizBang storage plugin.
> 
> pNFS means a never-ending arms race for the best storage layout, where 
> NFS clients are inevitably compatibly with a __random subset__ of total 
> available layout types.  pNFS will be a continuing train wreck of 
> fly-by-night storage companies, and their pet layout types & storage 
> protocols.
> 
> It is a support nightmare, an admin nightmare, a firewall nightmare, a 
> client implementor's nightmare, but a storage vendor's wet dream.
> 
> NFS was never beautiful, but at least until v4.0 it was well known and 
> widely cross-compatible.  And only required one network protocol: NFS.
> 
> 	Jeff
> 

I hear you. I'm paying close attention and noting down all of above
hazardous signals. However, please allow me my own on-look on the matter.
Perhaps one day soon, (Probably not in LSF, no travel budget approval yet),
we will meet and we can talk about it more closely, and maybe I could
convince you of other aspects as well.

But pragmatically speaking. All the above has nothing that I can do about it.
My job is to show an OO reference implementation of pNFS-objects, a public
and signed protocol. I admit that pNFS-objects is a Panasas's pet, which is
my boss and the inventor of pNFS. I hope to remove it from your above
SuperWhizBang category, please. Actually my job is so it will not be. I want
an open standard implementation from day one, so there will be no questions. I
understand that you argue about the do or die of the OSD protocol under pNFS.
For me it is just that much more challenge of swimming up stream, as a Salmon.
Everyone is doing "Files" I get to do "Objects". I hope when finally the code
will arrive, soon, and it gets to be used, it's merits, performance, security,
and ease-of-use will win users over, big time.
(Lets compare notes, what is the minimal NFS DS implementation you can imagine?
 What would you say an OSD's target is? not counting all the extras an OSD gives
 you, like no proprietary back-channel protocol between MDS-to-DS inside the cluster.)

But I do hear you, really, you have very valid points that must be taken into consideration.

Thanks
Boaz
