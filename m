From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Mon, 02 Jun 2014 14:57:26 -0700
Message-ID: <538CF346.2070504@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <4233989.Saca0ocOUr@wuerfel> <538CCFDE.2010107@zytor.com> <7175692.dpgYFMbTaP@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7175692.dpgYFMbTaP@wuerfel>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
>>
>> The bit that is really going to hurt is every single ioctl that uses a
>> timespec.
>>
>> Honestly, though, I really don't understand the point with "struct
>> inode_time".  It seems like the zeroeth-order thing is to change the
>> kernel internal version of struct timespec to have a 64-bit time... it
>> isn't just about inodes.  We then should be explicit about the external
>> uses of time, and use accessors.
> 
> I picked these because they are fairly isolated from all other uses,
> in particular since inode times are the only things where we really
> care about times in the distant past or future (decades away as opposed
> to things that happened between boot and shutdown).
> 

If nothing else, I would expect to be able to set the system time to
weird values for testing.  So I'm not so sure I agree with that...

> For other kernel-internal uses, we may be better off migrating to
> a completely different representation, such as nanoseconds since
> boot or the architecture specific ktime_t, but this is really something
> to decide for each subsystem.

Having a bunch of different time representations in the kernel seems
like a real headache...

	-hpa
