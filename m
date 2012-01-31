From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Tue, 31 Jan 2012 20:16:30 +0100
Message-ID: <4F283E0E.7010407@itwm.fraunhofer.de>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>  <4F2147BA.6030607@itwm.fraunhofer.de> <yq1k44e1pn6.fsf@sermon.lab.mkp.net>  <4F217F0C.6030105@itwm.fraunhofer.de> <1327620104.6151.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327620104.6151.23.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/27/2012 12:21 AM, James Bottomley wrote:
> On Thu, 2012-01-26 at 17:27 +0100, Bernd Schubert wrote:
>> On 01/26/2012 03:53 PM, Martin K. Petersen wrote:
>>>>>>>> "Bernd" == Bernd Schubert<bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>   writes:
>>>
>>> Bernd>   We from the Fraunhofer FhGFS team would like to also see the T10
>>> Bernd>   DIF/DIX API exposed to user space, so that we could make use of
>>> Bernd>   it for our FhGFS file system.  And I think this feature is not
>>> Bernd>   only useful for file systems, but in general, scientific
>>> Bernd>   applications, databases, etc also would benefit from insurance of
>>> Bernd>   data integrity.
>>>
>>> I'm attending a SNIA meeting today to discuss a (cross-OS) data
>>> integrity aware API. We'll see what comes out of that.
>>>
>>> With the Linux hat on I'm still mainly interested in pursuing the
>>> sys_dio interface Joel and I proposed last year. We have good experience
>>> with that I/O model and it suits applications that want to interact with
>>> the protection information well. libaio is also on my list.
>>>
>>> But obviously any help and input is appreciated...
>>>
>>
>> I guess you are referring to the interface described here
>>
>> http://www.spinics.net/lists/linux-mm/msg14512.html
>>
>> Hmm, direct IO would mean we could not use the page cache. As we are
>> using it, that would not really suit us. libaio then might be another
>> option then.
>
> Are you really sure you want protection information and the page cache?
> The reason for using DIO is that no-one could really think of a valid
> page cache based use case.  What most applications using protection
> information want is to say: This is my data and this is the integrity
> verification, send it down and assure me you wrote it correctly.  If you
> go via the page cache, we have all sorts of problems, like our
> granularity is a page (not a block) so you'd have to guarantee to write
> a page at a time (a mechanism for combining subpage units of protection
> information sounds like a nightmare).  The write becomes mark page dirty
> and wait for the system to flush it, and we can update the page in the
> meantime.  How do we update the page and its protection information
> atomically.  What happens if the page gets updated but no protection
> information is supplied and so on ...  The can of worms just gets more
> squirmy.  Doing DIO only avoids all of this.

Well, entirely direct-IO will not work anyway as FhGFS is a parallel 
network file system, so data are sent from clients to servers, so data 
are not entirely direct anymore.
The problem with server side storage direct-IO is that it is too slow 
for several work cases. I guess the write performance could be mostly 
solved somehow, but then still the read-cache would be entirely missing. 
 From Lustre history I know that server side read-cache improved 
performance of applications at several sites. So I really wouldn't like 
to disable it for FhGFS...
I guess if we couldn't use the page cache, we probably wouldn't attempt 
to use DIF/DIX interface, but will calculate our own checksums once we 
are going to work on the data integrity feature on our side.


Cheers,
Bernd


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
