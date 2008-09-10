From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef
 and macros for accessing 3-byte arrays as integers
Date: Wed, 10 Sep 2008 21:04:01 +0300
Message-ID: <48C80C11.9080103@panasas.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>		<20080910140712.GA12280@infradead.org>	<1221061241.27385.14.camel@norville.austin.ibm.com>
	<48C7F4EC.1080709@intel.com> <48C807A9.60509@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <48C807A9.60509@intel.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Sender: jfs-discussion-bounces@lists.sourceforge.net
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
To: Chris Leech <christopher.leech@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, jfs-discussion@lists.sourceforge.net, Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chris Leech wrote:
> Chris Leech wrote:
>> Dave Kleikamp wrote:
>>> @@ -62,7 +60,7 @@ struct timestruc_t {
>>>   */
>>>  typedef struct {
>>>  	unsigned len:24;
>>> -	unsigned off1:8;
>>> +	u8 off1;
>>>  	u32 off2;
>>>  } lxd_t;
>> Shouldn't len here be changed to a __le24?  I think this just changed
>> the size of lxd_t by a byte.
> 
> Never mind, I see that it's a host order field.  And presently surprised
> to see that gcc combines the 24-bit bitfield with the following u8.
> 
> Chris

It does because these are all bytes. on x86. But this is not guarantied
for all ARCHs and machine-word-sizes. In any way this should be consistent
with the rest of the file.

Please see my other reply about packing of structures. If this is
on-the-wire then there are problems.

Boaz

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
