From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 11:58:58 -0400
Message-ID: <482C5DC2.7000100@scalableinformatics.com>
References: <482B7FE4.9070502@fusionio.com>	<694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
	<482C5293.5090005@fusionio.com>
	<482C55E2.8060905@scalableinformatics.com>
	<482C5BC4.6090301@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <482C5BC4.6090301@fusionio.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Cameron Harr <charr@fusionio.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, general@lists.openfabrics.org
List-Id: linux-scsi@vger.kernel.org

Cameron Harr wrote:
> Joe Landman wrote:
>> This is only 8 GB of IO.  It is possible that (despite dio) you are 
>> caching.  Make the IO much larger than RAM.  Use a count of 128m or so.
> 
> This is going to sound dumb, but I thought I had 4 GB of RAM and thus 
> intentionally used a file size 2x my physical RAM. As it turns out, I 
> have 32GB of RAM on the box (4G usually shows up as 38.... and I just 
> saw the 3). Anyway, with a 64GB file the numbers are looking more 
> accurate (and even low):
> 393.3 MB/s

This is about right.  We were seeing ~650MB/s iSER for a 1.3 TB file dd 
on our units, but it bounced all over the place in terms of rates.  Very 
hard to pin down a single performance number.  Locally the drives were 
 >750 MB/s, so 650 isn't terrible.

>> We have found dd to be quite trustworthy with [oi]flag=direct.
> I like it too. At any rate, I'm going to need to do some new testing to 
> avoid the ram size (might just set a mem limit on the boot line).
> 
> There's still a bit of a discrepancy between IOP performance with iSer 
> and srpt. Has anyone else done comparisons with the two? I think Erez 
> was hoping to get some numbers before too long.
> Cameron


I think it might be coalescing the IOPs somehow (what do your elevators 
look like, how deep are your queues).  Each drive can do 100-300 IOPs 
best case.  30000 IOPs is 100-300 drives.  Or 
caching/coalescing/elevators in action.

Joe


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423
fax  : +1 866 888 3112
cell : +1 734 612 4615
