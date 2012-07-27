From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Fri, 27 Jul 2012 08:50:12 +0200
Message-ID: <50123A24.9040403@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <CAKviJvVrrtyjFOzu7jmmD7cpXZcXtyQ+7HDy1G1o2_a0JRss5w@mail.gmail.com> <500FE952.9030001@panasas.com> <CAKviJvV00Br4e455+_gdYyg6pdbdDqQnMC2NMTv-3ZyFgxvZ9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKviJvV00Br4e455+_gdYyg6pdbdDqQnMC2NMTv-3ZyFgxvZ9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Sen <kelvin.xupt@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 27/07/2012 05:12, Wang Sen ha scritto:
>> > No this code is correct, though you will need to make sure to properly
>> > terminate the destination sg_list.
> Yes, the terminate marker in the destination list is set when initialization.
> sg_set_page would not break this marker because it saved both the two
> maker bits at sg_asign_page.
> 
> Also, the allocation of destination sg list considered the total number of
> the source sg_list. So, sg_set_page can work correctly.
> 
> The value assignment method also can also work correctly, because the
> termination marker in source sg_list has been set in blk_rq_map_sg(), as
> the last entry of source sg_list is just copied to the the last entry
> in destination
> list.
> 
> Uh, Paolo, Boaz, have  you reached agreement on which method to use?

Let's use the value assignment, and document it in the commit message as
follows:

Value assignment creates a well-formed scatterlist, because the
termination marker in source sg_list has been set in blk_rq_map_sg().
The last entry of the source sg_list is just copied to the the last
entry in destination list.  Note that, for now, virtio_ring does not
care about the form of the scatterlist and simply processes the first
out_num + in_num consecutive elements of the sg[] array.

Paolo
