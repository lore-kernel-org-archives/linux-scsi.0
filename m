Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057F221357
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 08:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705912841; cv=none; b=nBoCaVww5LOrSwjBxQZJ8oB2BNh9r+tnDYyu16vwwJ5AENtQcNM9F6LirqHSz/eMVGu+9HDt86R5uavCxqRkeoQyoauASQv/ku4jrU266ZrYF8+35PKlpKPMiGdbUtOu1Leo70xWS1D6En61ubIFzVe03Q2+8p5qDFmHaXdJfmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705912841; c=relaxed/simple;
	bh=azHKYl+eTxb5AxMTD37LwbJgKWtPnQF+7Rs4PS3L/1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=feI20okYhh6U5Tq+9SkIhmKYNJyuuPdMSrOHEwDkP1MuqzzC3i2zGxWcpbKRp+mzY/KW41Hyi7EL6HLjpStCnRh+iePe2F6GRt5xJVQaFV9vGPTYbfsSgd7/hEuE8Bxe0aUujLwHecCOOq3YpRslREsJ0D3Z0gile1g6C0I/0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP0TSORT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP0TSORT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E107C43390
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 08:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705912840;
	bh=azHKYl+eTxb5AxMTD37LwbJgKWtPnQF+7Rs4PS3L/1A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gP0TSORTCb2usTtVucty1u8nTRkjaktZHUbY2j956yYwzWLF24Qen/gS0//s8puw9
	 z4/h+5vPqdsfLk7UaYHmc0nVcXHrPQj+xKf02vKRR3/CE8hEHT6cWk7dMQeb3OZwK6
	 M/jrJKjJoiiva7aVaxcZHsKt7zZhCEm107eE+jKnLTKbjX6jkPjjw2oil5XFJcsGrm
	 X8FNXaQzHF1lXLDzTN4YbPD6ZMIbdin8BfEW6fR4jMtbV7Lk8DHfO1vXSxTCgdMc6K
	 /rCB8tNbYRk4Zd38zKsGEk4SULX29CQDS2/yvLDM0+dZzV2b6yn4vgquDxzu9y3xkF
	 qbguG0vhjZ1zA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 59E9AC53BD2; Mon, 22 Jan 2024 08:40:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Mon, 22 Jan 2024 08:40:40 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: fatalfeel@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-151631-11613-nIYdLOok7r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D151631

--- Comment #12 from Jesse Stone (fatalfeel@hotmail.com) ---
//if under linux 4.12 (include 4.12) add this patch
void __scsi_remove_device(struct scsi_device *sdev)
{
    struct device *dev =3D &sdev->sdev_gendev;
    int res;
    int ret;

    /*
     * This cleanup path is not reentrant and while it is impossible
     * to get a new reference with scsi_device_get() someone can still
     * hold a previously acquired one.
     */
    if (sdev->sdev_state =3D=3D SDEV_DEL)
        return;

    if (sdev->is_visible) {
        /*
         * If scsi_internal_target_block() is running concurrently,
         * wait until it has finished before changing the device state.
         */
        mutex_lock(&sdev->state_mutex);
        /*
         * If blocked, we go straight to DEL and restart the queue so
         * any commands issued during driver shutdown (like sync
         * cache) are errored immediately.
         */
        res =3D scsi_device_set_state(sdev, SDEV_CANCEL);
        //if (res !=3D 0) {
        ret =3D scsi_device_set_state(sdev, SDEV_DEL);
        if ( !ret )
        {
            scsi_start_queue(sdev);
        }
        //}
        mutex_unlock(&sdev->state_mutex);

        if (res !=3D 0)
            return;

        bsg_unregister_queue(sdev->request_queue);
        device_unregister(&sdev->sdev_dev);
        transport_remove_device(dev);
        scsi_dh_remove_device(sdev);
        device_del(dev);
    } else {
        put_device(&sdev->sdev_dev);
    }

    /*
     * Stop accepting new requests and wait until all queuecommand() and
     * scsi_run_queue() invocations have finished before tearing down the
     * device.
     */
    mutex_lock(&sdev->state_mutex);
    scsi_device_set_state(sdev, SDEV_DEL);
    mutex_unlock(&sdev->state_mutex);

    blk_cleanup_queue(sdev->request_queue);
    cancel_work_sync(&sdev->requeue_work);

    if (sdev->host->hostt->slave_destroy)
    {
        sdev->host->hostt->slave_destroy(sdev);
    }

    transport_destroy_device(dev);

    /*
     * Paired with the kref_get() in scsi_sysfs_initialize().  We have
     * remoed sysfs visibility from the device, so make the target
     * invisible if this was the last device underneath it.
     */
    scsi_target_reap(scsi_target(sdev));

    put_device(dev);
}

//if above linux 4.13 (include 4.13)
void __scsi_remove_device(struct scsi_device *sdev)
{
        struct device *dev =3D &sdev->sdev_gendev;
        int res;
#ifdef MY_PATCH=20
        int ret;
#endif=20=20

        /*
         * This cleanup path is not reentrant and while it is impossible
         * to get a new reference with scsi_device_get() someone can still
         * hold a previously acquired one.
         */
        if (sdev->sdev_state =3D=3D SDEV_DEL)
                return;

        if (sdev->is_visible) {
                /*
                 * If scsi_internal_target_block() is running concurrently,
                 * wait until it has finished before changing the device st=
ate.
                 */
                mutex_lock(&sdev->state_mutex);
                /*
                 * If blocked, we go straight to DEL and restart the queue =
so
                 * any commands issued during driver shutdown (like sync
                 * cache) are errored immediately.
                 */
                res =3D scsi_device_set_state(sdev, SDEV_CANCEL);
#ifdef MY_PATCH
                ret =3D scsi_device_set_state(sdev, SDEV_DEL);
                if ( !ret )
                        scsi_start_queue(sdev);
#else
                if (res !=3D 0) {
                        res =3D scsi_device_set_state(sdev, SDEV_DEL);
                        if (res =3D=3D 0)
                                scsi_start_queue(sdev);
                }
#endif=20=20=20=20=20=20=20=20=20=20
                mutex_unlock(&sdev->state_mutex);

                if (res !=3D 0)
                        return;

                if (sdev->host->hostt->sdev_groups)
                        sysfs_remove_groups(&sdev->sdev_gendev.kobj,
                                        sdev->host->hostt->sdev_groups);

                bsg_unregister_queue(sdev->request_queue);
                device_unregister(&sdev->sdev_dev);
                transport_remove_device(dev);
                device_del(dev);
        } else
                put_device(&sdev->sdev_dev);

        /*
         * Stop accepting new requests and wait until all queuecommand() and
         * scsi_run_queue() invocations have finished before tearing down t=
he
         * device.
         */
        mutex_lock(&sdev->state_mutex);
        scsi_device_set_state(sdev, SDEV_DEL);
        mutex_unlock(&sdev->state_mutex);

        blk_cleanup_queue(sdev->request_queue);
        cancel_work_sync(&sdev->requeue_work);

        if (sdev->host->hostt->slave_destroy)
                sdev->host->hostt->slave_destroy(sdev);
        transport_destroy_device(dev);

        /*
         * Paired with the kref_get() in scsi_sysfs_initialize().  We have
         * removed sysfs visibility from the device, so make the target
         * invisible if this was the last device underneath it.
         */
        scsi_target_reap(scsi_target(sdev));

        put_device(dev);
}

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
