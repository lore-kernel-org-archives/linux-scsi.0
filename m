From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/9] dmapool: cleanup error messages
Date: Fri, 3 Aug 2018 18:59:20 +0300
Message-ID: <CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ@mail.gmail.com>
References: <a9f7ca9a-38d5-12e2-7d15-ab026425e85a@cybernetics.com>
	<CAHp75Ve0su_S3ZWTtUEUohrs-iPiD1uzFOHhesLrWzJPOa2LNg@mail.gmail.com>
	<7a943124-c65e-f0ed-cc5c-20b23f021505@cybernetics.com>
	<b8547f8d-ac88-3d7b-9c2d-60a2f779259e@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <b8547f8d-ac88-3d7b-9c2d-60a2f779259e-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 3, 2018 at 6:17 PM, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> wrote:
> On 08/03/2018 09:41 AM, Tony Battersby wrote:
>> On 08/03/2018 04:56 AM, Andy Shevchenko wrote:
>>> On Thu, Aug 2, 2018 at 10:57 PM, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> wrote:
>>>> Remove code duplication in error messages.  It is now safe to pas a NULL
>>>> dev to dev_err(), so the checks to avoid doing so are no longer
>>>> necessary.
>>>>
>>>> Example:
>>>>
>>>> Error message with dev != NULL:
>>>>   mpt3sas 0000:02:00.0: dma_pool_destroy chain pool, (____ptrval____) busy
>>>>
>>>> Same error message with dev == NULL before patch:
>>>>   dma_pool_destroy chain pool, (____ptrval____) busy
>>>>
>>>> Same error message with dev == NULL after patch:
>>>>   (NULL device *): dma_pool_destroy chain pool, (____ptrval____) busy
>>> Have you checked a history of this?
>>>
>>> I'm pretty sure this was created in an order to avoid bad looking (and
>>> in some cases frightening) "NULL device *" part.
>>>
>>> If it it's the case, I would rather leave it as is, and even not the
>>> case, I'm slightly more bent to the current state.
>>>
>> I did.  "drivers/base/dmapool.c", later moved to "mm/dmapool.c", was
>> added in linux-2.6.3, for which dev_err() did not work will a NULL dev,
>> so the check was necessary back then.  I agree that the (NULL device *):
>> bit is ugly, but these messages should be printed only after a kernel
>> bug, so it is not like they will be making a regular appearance in
>> dmesg.  Considering that, I think that it is better to keep it simple.
>>
>
> My original unsubmitted patch used the following:
>
> +#define pool_err(pool, fmt, args...) \
> +       do { \
> +               if ((pool)->dev) \
> +                       dev_err((pool)->dev, fmt, args); \
> +               else \
> +                       pr_err(fmt, args); \
> +       } while (0)
>
> But then I decided to simplify it to just use dev_err().  I still have
> the old version.  When I submit v3 of the patchset, which would you prefer?

JFYI: git log --no-merges --grep 'NULL device \*'

P.S. I already shared my opinion on this anyway.

-- 
With Best Regards,
Andy Shevchenko
