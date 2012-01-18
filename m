From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 01:42:12 +0200
Message-ID: <4F1758D4.9010401@panasas.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120118232200.GA22019@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 01/19/2012 01:22 AM, Jan Kara wrote:
> On Wed 18-01-12 14:58:08, Darrick J. Wong wrote:
>> On Tue, Jan 17, 2012 at 10:36:48PM +0100, Jan Kara wrote:
>>> On Tue 17-01-12 15:06:12, Mike Snitzer wrote:
>>>> 5) Any more progress on stable pages?
>>>>    - I know Darrick Wong had some proposals, what remains?
>>>   As far as I know this is done for XFS, btrfs, ext4. Is more needed?
>>
>> Yep, it's done for those three fses.
>>
>> I suppose it might help some people if instead of wait_on_page_writeback we
>> could simply page-migrate all the processes onto a new page...?

>   Well, but it will cost some more memory & copying so whether it's faster
> or not pretty much depends on the workload, doesn't it? Anyway I've already
> heard one guy complaining that his RT application does redirtying of mmaped
> pages and it started seeing big latencies due to stable pages work. So for
> these guys migrating might be an option (or maybe fadvise/madvise flag to
> do copy out before submitting for IO?).
> 

OK That one is interesting. Because I'd imagine that the Kernel would not
start write-out on a busily modified page.

Some heavy modifying then a single write. If it's not so then there is already
great inefficiency, just now exposed, but was always there. The "page-migrate"
mentioned here will not help.

Could we not better our page write-out algorithms to avoid heavy contended pages?

Do you have a more detailed description of the workload? Is it theoretically
avoidable?

>> Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/write?
>> (I never really bothered to find out if it really does this.)

md-raid5/1 currently copies all pages if that what you meant.

>   Not sure either. Neil should know :) (added to CC).
> 
> 								Honze

Thanks
Boaz
