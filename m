From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/5] virtio-scsi: allocate target pointers in a separate
	memory block
Date: Tue, 28 Aug 2012 16:25:26 +0200
Message-ID: <503CD4D6.40503@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-4-git-send-email-pbonzini@redhat.com>
	<503CD097.2020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <503CD097.2020900@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Sasha Levin <levinsasha928@gmail.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 28/08/2012 16:07, Sasha Levin ha scritto:
>> > -	num_targets = sh->max_id;
>> > -	for (i = 0; i < num_targets; i++) {
>> > -		kfree(vscsi->tgt[i]);
>> > -		vscsi->tgt[i] = NULL;
>> > +	if (vscsi->tgt) {
>> > +		num_targets = sh->max_id;
>> > +		for (i = 0; i < num_targets; i++) {
>> > +			kfree(vscsi->tgt[i]);
> Since we now kmalloc() the vscsi->tgt array, it doesn't get zeroed anymore.
> 
> This means that if for example, num_targets=3, and the second
> virtscsi_alloc_tgt() in virtscsi_init() failed, we're going to kfree() garbage here.

Right, changed to kzalloc.

Paolo
